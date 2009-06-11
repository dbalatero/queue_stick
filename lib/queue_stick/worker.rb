module QueueStick
  class Worker
    class ShellCommandError < StandardError; end

    # TODO(dbalatero): configurable?
    MAX_ERRORS = 5

    attr_reader :errors

    @@counters = Hash.new { |h, k| h[k] = [] }

    def initialize
      @errors = []
      create_counters!
    end

    # This method needs to return either:
    # a) a Message object if there is something in the queue
    # b) nil if there is nothing in the queue
    def get_message_from_queue
      raise NotImplementedError, "#get_message_from_queue needs to be implemented in a subclass."
    end

    def delete_message_from_queue(message)
      raise NotImplementedError, "#delete_message_from_queue needs to be implemented in a subclass."
    end
    
    # This method will run a shell command, and return the
    # output of the command's run.
    #
    # It will loudly raise an error if the shell command fails,
    # which, if raised in your process() method, will be 
    # guaranteed to hit your recover() method.
    def shell_run(cmd)
      result = `#{cmd}`
      process_status = $?
      
      if !process_status.success?
        # TODO(dbalatero): get the stderr output.
        raise ShellCommandError, "Error running shell command: #{cmd}"
      end

      result
    end

    def run_loop
      # Exit the run loop if we get a shutdown request.
      Thread.current.exit if Thread.current[:shutdown]

      message = get_message_from_queue
      if message.nil?
        sleep(5)
      else

        begin
          process(message.body)
          delete_message_from_queue(message)
          counter(:messages_processed).increment!
        rescue Exception => process_error
          error = WorkerError.new(message)
          error.exceptions << process_error
          begin
            recover(message.body)
          rescue Exception => recover_error
            error.exceptions << recover_error
          end
          @errors << error
          @errors.shift if @errors.size > MAX_ERRORS
          counter(:errors_caught).increment!
        end
      end
    end

    def process(message)
      raise NotImplementedError, "Your worker class needs to implement def process(message)!"
    end

    def recover(message)
      raise NotImplementedError, "Your worker class needs to implement def recover(message)!"
    end

    def counter(counter_name)
      @counters[counter_name]
    end

    def create_counters!
      @counters = {}
      self.class.counters.each do |counter_name|
        @counters[counter_name] = BlendedCounter.new(counter_name, 1, 10, 30, 60)
      end
    end
    private :create_counters!

    def self.counter(name)
      @@counters[self] << name unless @@counters[self].include?(name)
    end

    def self.counters
      @@counters[self]
    end

    def self.inherited(child)
      child.initialize_default_counters
    end

    protected
    def self.initialize_default_counters
      counter :messages_processed
      counter :errors_caught
    end

    initialize_default_counters 
  end
end
