module QueueStick
  class SQSWorker < Worker
    @@queue_names = {}
    @@visibility_timeouts = Hash.new { |h, k| h[k] = 60 }

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
