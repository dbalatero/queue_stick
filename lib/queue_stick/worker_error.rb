module QueueStick
  class WorkerError
    attr_reader :message, :timestamp
    attr_accessor :exceptions

    def initialize(message)
      @message = message
      @timestamp = Time.now
      @exceptions = []
    end
  end
end
