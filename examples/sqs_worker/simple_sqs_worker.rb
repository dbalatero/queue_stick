require File.dirname(__FILE__) + '/../../lib/queue_stick'

class SimpleSQSWorker < QueueStick::SQSWorker
  aws_access_key_id '1N2G2X8M88XC4KTYRHG2'
  aws_secret_access_key 'yQHr7PhLOfBkpnaK1MbPBcDxKKO6snAW500f3Lyl'
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
