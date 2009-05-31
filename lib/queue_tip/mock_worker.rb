module QueueStick
  class MockWorker < Worker
    MOCK_MESSAGE = MockMessage.new("foomessage")
    def get_message_from_queue
      MOCK_MESSAGE
    end

    def delete_message_from_queue(message)
      # no-op
    end
  end
end
