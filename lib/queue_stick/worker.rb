module QueueStick
  class Worker
    # TODO(dbalatero): configurable?
    MAX_ERRORS = 50

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

    def run_loop
      # Exit the run loop if we get a shutdown request.
      Thread.current.exit if Thread.current[:shutdown]

      message = get_message_from_queue

      begin
        process(message.body)
        delete_message_from_queue(message)
        counter(:messages_processed).increment!
      rescue Exception => process_error
        error = WorkerError.new(message.id)
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
    end

    initialize_default_counters 
  end
end
