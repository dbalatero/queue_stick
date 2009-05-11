module QueueTip
  class Worker
    def self.queue_name(name = nil)
      if name.nil?
        @@queue_name
      else
        @@queue_name = name
      end
    end
  end
end
