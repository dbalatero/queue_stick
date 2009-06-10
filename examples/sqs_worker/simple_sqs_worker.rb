require File.dirname(__FILE__) + '/../../lib/queue_stick'

class SimpleSQSWorker < QueueStick::SQSWorker
  aws_access_key_id '<your key here>'
  aws_secret_access_key '<your secret here>'
  queue_name 'my_test_queue'
  visibility_timeout 120

  # This worker just prints out the message from the SQS
  # queue.
  def process(message)
    puts "Got message from SQS: " << message
    sleep 2
  end

  def recover(message)
    puts "whoops, there was an error with message: #{message}. oh well!"
  end
end
