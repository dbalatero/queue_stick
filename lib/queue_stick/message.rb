module QueueStick
  class Message
    attr_reader :raw_message

    def initialize(raw_message)
      @raw_message = raw_message
    end

    def body
      raise NotImplementedError, "#body needs to be implemented in a subclass of QueueStick::Message"
    end
  end
end
