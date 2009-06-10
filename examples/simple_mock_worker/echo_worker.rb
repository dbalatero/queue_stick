require File.dirname(__FILE__) + '/../../lib/queue_stick'

class EchoWorker < QueueStick::MockWorker
  def process(message)
    if rand < 0.15
      # 15% chance of raising an error!
      raise ArgumentError, "We got an error processing this message!"
    else
      puts message
      sleep 2
    end
  end

  def recover
    puts "whoops, there was an error. oh well!"
  end
end
