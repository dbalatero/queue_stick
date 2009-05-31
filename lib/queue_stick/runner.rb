require 'optparse'
require 'ostruct'

module QueueStick
  class Runner
    class MissingPortError < ArgumentError; end

    def initialize(argv, io_stream = STDOUT)
      parse_opts!(argv)
      validate_opts!
    end

    private
    def parse_opts!(argv)
      @options = OpenStruct.new(
        :disable_web_server => false
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
      end
      parser.parse!(argv)
    end

    def validate_opts!
      if !@options.disable_web_server and !(0..65535).include?(@options.port)
        raise MissingPortError, 'QueueStick requires an HTTP port to be passed in with -p or --port.'
      end
    end
  end
end
