module QueueStick
  class SQSMessage < Message
    def id
      @raw_message[:id]
    end

    def body
      @raw_message[:body]
    end
  end
end
