module QueueTip
  class WorkerError
    attr_reader :message_id, :timestamp
    attr_accessor :exceptions

    def initialize(message_id)
      @message_id = message_id
      @timestamp = Time.now
      @exceptions = []
    end
  end
end
