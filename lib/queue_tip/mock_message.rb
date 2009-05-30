module QueueTip
  class MockMessage < Message
    def body
      @raw_message
    end
  end
end
