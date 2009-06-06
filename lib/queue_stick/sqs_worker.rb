module QueueStick
  class SQSWorker < Worker
    @@access_keys = {}
    @@secret_keys = {}
    @@queue_names = {}
    @@visibility_timeouts = Hash.new { |h, k| h[k] = 60 }

    def initialize
      @sqs = RightAws::SqsGen2.new(self.class.aws_access_key_id,
                                     self.class.aws_secret_access_key,
                                     :multi_thread => false,
                                     :signature_version => '1')

      # Create the queue if it doesn't exist
      @sqs_queue = @sqs.queue(self.class.queue_name.to_s, true)
    end

    def delete_message_from_queue(message)
      message.raw_message.delete
    end

    def get_message_from_queue
      message = @sqs_queue.pop
      message ? QueueStick::SQSMessage.new(message) : nil
    end

    def self.aws_access_key_id(access_key = nil)
      if access_key.nil?
        @@access_keys[self]
      else
        @@access_keys[self] = access_key
      end
    end

    def self.aws_secret_access_key(secret_key = nil)
      if secret_key.nil?
        @@secret_keys[self]
      else
        @@secret_keys[self] = secret_key
      end
    end

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
