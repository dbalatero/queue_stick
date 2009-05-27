module QueueTip
  class Worker
    def process(message)
      raise NotImplementedError, "Your worker class needs to implement def process(message)!"
    end

    def recover
      raise NotImplementedError, "Your worker class needs to implement def recover()!"
    end

    def self.queue_name(name = nil)
      if name.nil?
        @@queue_name
      else
        @@queue_name = name
      end
    end
  end
end
