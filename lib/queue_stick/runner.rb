require 'optparse'
require 'ostruct'

module QueueStick
  class Runner
    class MissingPortError < ArgumentError; end
    class NumWorkersError < ArgumentError; end

    attr_reader :workers
    attr_reader :start_time

    def initialize(argv, io_stream = STDOUT)
      parse_opts!(argv)
      validate_opts!
      @io = io_stream
      @start_time = Time.now.freeze
    end

    def run!(worker_klass)
      @io.puts "================================="
      @io.puts "Booting up a queue_stick worker..."

      initialize_workers!(worker_klass)
      start_web_server! unless @options.disable_web_server
      start_workers!
    end

    def initialize_workers!(worker_klass)
      @io.puts "Initializing #{@options.num_workers} workers..."
      @workers = []
      @options.num_workers.times { @workers << worker_klass.new }
    end

    def start_web_server!
      @io.puts "Starting a web server on port #{@options.port}..."
      Thread.new(@options.port, self) do |port, runner|
        require 'sinatra/base'
        app = Sinatra.new(QueueStick::WebServer) do
          set :port, port
          set :queue_runner, runner
        end
        app.run!
      end
    end

    def errors
      workers.map { |worker|
        worker.errors
      }.flatten!
    end

    def start_workers!
      @io.puts "Starting up #{workers.size} workers..."
      @threads = workers.map do |worker|
        Thread.new do
          worker.run_loop while true
        end
      end
      @threads.each { |thread| thread.join }
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
