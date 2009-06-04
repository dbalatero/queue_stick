module QueueStick
  class MockMessage < Message
    def body
      @raw_message
    end

    def id
      rand(100000000).to_s
    end
  end
end
