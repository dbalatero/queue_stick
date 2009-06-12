require 'optparse'
require 'ostruct'

module QueueStick
  class Runner
    class MissingPortError < ArgumentError; end
    class NumWorkersError < ArgumentError; end

    STATUSES = [:booting, :running, :shutting_down]

    attr_reader :workers
    attr_reader :start_time
    attr_reader :status

    def initialize(argv, io_stream = STDOUT)
      parse_opts!(argv)
      validate_opts!

      @io = io_stream
      @start_time = Time.now.freeze
      @status = :booting
    end

    def run!(worker_klass)
      @io.puts "================================="
      @io.puts "Booting up a queue_stick worker..."

      initialize_workers!(worker_klass)
      unless @options.disable_web_server
        @sinatra_thread = start_web_server!
      end
      start_workers!
    end

    def initialize_workers!(worker_klass)
      @io.puts "Initializing #{@options.num_workers} workers..."
      @workers = []
      @options.num_workers.times { @workers << worker_klass.new }
    end

    def port
      @options.port
    end

    def start_web_server!
      runner = self
      port = @options.port
      @sinatra_app = Sinatra.new(QueueStick::WebServer) do
        set :port, port
        set :queue_runner, runner
      end

      # Raise errors in the main thread, but don't join.
      main = Thread.current
      Thread.new(@sinatra_app) do |app|
        begin
          app.run!
        rescue Exception => error
          main.raise error
        end
      end
    end

    def errors
      workers.map { |worker| worker.errors }.flatten
    end

    def start_workers!
      @threads = []

      unless $DISABLE_TRAPS # make our tests not trap(:INT).
        # Make sure we register our trap(:INT)
        # *after* Sinatra registers its trap(:INT),
        # otherwise we will be fucked.
        while @sinatra_app
          break if $TRAP_INT_OCCURRED
        end

        trap(:INT) do
          # Shutdown each thread on Ctrl+C
          puts "Got Ctrl+C... waiting for #{@threads.size} threads to finish their current job."
          shutdown!
        end
      end

      @io.puts "Starting up #{workers.size} workers..."
      @threads = workers.map do |worker|
        Thread.new do
          loop do
            worker.run_loop
          end
        end
      end

      @status = :running

      @threads.each { |thread| thread.join }
    end

    def booting?
      status == :booting
    end

    def running?
      status == :running
    end

    def shutting_down?
      status == :shutting_down
    end

    def shutdown!
      @status = :shutting_down

      @threads.each do |thread|
        thread[:shutdown] = true 
      end
    end

    private
    def parse_opts!(argv)
      @options = OpenStruct.new(
        :disable_web_server => false,
        :num_workers => 1
      )

      parser = OptionParser.new do |opts|
        opts.on('-p',
                '--port NUMBER',
                'Bind the queue worker\'s HTTP server to port NUMBER.') do |port|
          @options.port = port.to_i
        end

        opts.on('-D',
                '--disable-web-server',
                'Disable the HTTP monitoring server.') do |bool|
          @options.disable_web_server = bool
        end

        opts.on('-n',
                '--num-workers NUMBER',
                'How many threaded queue workers do you want? (default = 1)') do |num_workers|
          @options.num_workers = (num_workers.nil? || num_workers.to_i < 1) ? 
              1 : num_workers.to_i
        end
      end
      parser.parse!(argv)
    end

    def validate_opts!
      validate_disable_web_server!
    end

    def validate_disable_web_server!
      if !@options.disable_web_server and !(0..65535).include?(@options.port)
        raise MissingPortError, 'QueueStick requires an HTTP port to be passed in with -p or --port.'
      end
    end
  end
end
