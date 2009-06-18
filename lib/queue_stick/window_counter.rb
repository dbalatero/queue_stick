require 'thread'

module QueueStick
  # This maintains a counter for a certain time window, aka
  # "the count for the last <window> minutes from Time.now"
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
      
      @expiry_threshold = @window * 1.5

      @counts = Hash.new { |h, k| h[k] = 0 }
      @mutex = Mutex.new
    end

    # Returns the current count for the last <window>
    # minutes.
    def count
      range = current_range

      sum = 0
      @mutex.synchronize do
        range.each do |key|
          sum += @counts[key]
        end
      end
      sum
    end

    # Increments the counter.
    def increment!(by = 1)
      expire_tracked_minutes! if tracked_minutes >= @expiry_threshold

      current_minute = self.class.current_minute
      @mutex.synchronize do
        @counts[current_minute] += by
      end
    end

    # :nodoc
    def tracked_minutes
      @counts.size
    end

    private
    def current_range
      current_minute = self.class.current_minute
      (current_minute - @window)..current_minute
    end

    def expire_tracked_minutes!
      @mutex.synchronize do
        range = current_range
        @counts.delete_if { |k, v| !current_range.include?(k) }
      end
    end

    def self.current_minute
      minute_for(Time.now)
    end

    def self.minute_for(time)
      (time.to_f / 60).round
    end
  end
end
