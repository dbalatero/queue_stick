module QueueTip
  class Worker
    MAX_ERRORS = 50

    attr_reader :errors

    @@queue_names = {}
    @@visibility_timeouts = Hash.new { |h, k| h[k] = 60 }
    
    def initialize
      @errors = []
    end

    # TODO(dbalatero): implement
    def delete_message_from_queue(message)
    end

    def run_loop
      # TODO(dbalatero): pull the message out
      message = nil

      begin
        process(message) # TODO(dbalatero): send body
        delete_message_from_queue(message)
      rescue Exception => process_error
        error = WorkerError.new(:dummy_id) # TODO(dbalatero): message_id?!
        error.exceptions << process_error
        begin
          recover
        rescue Exception => recover_error
          error.exceptions << recover_error
        end
        @errors << error
        @errors.shift if @errors.size > MAX_ERRORS
      end
    end

    def process(message)
      raise NotImplementedError, "Your worker class needs to implement def process(message)!"
    end

    def recover
      raise NotImplementedError, "Your worker class needs to implement def recover()!"
    end

    def self.queue_name(name = nil)
      if name.nil?
        @@queue_names[self]
      else
        @@queue_names[self] = name
      end
    end

    def self.visibility_timeout(timeout = nil)
      if timeout.nil?
        @@visibility_timeouts[self]
      else
        @@visibility_timeouts[self] = timeout
      end
    end
  end
end
