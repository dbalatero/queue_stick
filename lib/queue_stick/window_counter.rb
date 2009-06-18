require 'thread'

module QueueStick
  class WindowCounter
    attr_reader :name

    # Time window is in minutes.
    def initialize(name, window)
      raise ArgumentError,
            'counter requires a name' if name.nil?
      raise ArgumentError,
            'counter requires a time window' if window.nil?
      
      @name = name
      @window = window

      @counts = Hash.new { |h, k| h[k] = 0 }
      @mutex = Mutex.new
    end

    def count
      current_minute = self.class.current_minute
      range = (current_minute - @window)..current_minute
      sum = 0
      @mutex.synchronize do
        range.each do |key|
          sum += @counts[key]
        end
      end
      sum
    end

    def increment!(by = 1)
      current_minute = self.class.current_minute
      @mutex.synchronize do
        @counts[current_minute] += by
      end
    end

    private
    def self.current_minute
      minute_for(Time.now)
    end

    def self.minute_for(time)
      (time.to_f / 60).round
    end
  end
end
