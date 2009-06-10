require File.dirname(__FILE__) + '/../../lib/queue_stick'

class EchoWorker < QueueStick::MockWorker
  def process(message)
    if rand < 0.25
      # I like these odds!
      raise ArgumentError, "We got an error processing this message!"
    else
      puts message
      sleep 4
    end
  end

  def recover(message)
    puts "whoops, there was an error with message: #{message}. oh well!"
  end
end
