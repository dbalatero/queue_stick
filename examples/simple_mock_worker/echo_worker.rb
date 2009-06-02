require File.dirname(__FILE__) + '/../../lib/queue_stick'

class EchoWorker < QueueStick::MockWorker
  def process(message)
    puts message
    sleep 2
  end

  def recover
    puts "whoops, there was an error. oh well!"
  end
end
