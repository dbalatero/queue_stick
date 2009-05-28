module QueueTip
  class Worker
    @@queue_names = {}

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
