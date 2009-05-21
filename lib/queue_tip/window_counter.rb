module QueueTip
  class WindowCounter
    attr_reader :name

    # Time window is in minutes.
    def initialize(name, window)
      raise ArgumentError,
            'counter requires a name' if name.nil?
      raise ArgumentError,
            'counter requires a time window' if window.nil?
      @name = name

      # Converted to seconds.
      @window = window * 60
      @count = 0

      @counts = []
      @timings = []
    end

    def count
      to_delete = []
      sum = 0
      threshold = threshold_time
      
      @counts.each_index do |i|
        if @timings[i] < threshold
          to_delete << i
        else
          sum += @counts[i]
        end
      end

      to_delete.each do |i|
        @counts.delete_at(i)
        @timings.delete_at(i)
      end

      sum
    end

    def increment!(by = 1)
      current = Time.now
      current -= current.sec
      timing = @timings.last

      if timing and 
         times_have_same_minute?(current, timing)
        @counts[@counts.size - 1] += by
      else
        @counts << by
        @timings << current
      end
    end

    private
    def times_have_same_minute?(time1, time2)
      (time1.min == time2.min and
      time1.hour == time2.hour and
      time1.day == time2.day and
      time1.month == time2.month and
      time1.year == time2.year)
    end

    def threshold_time
      current = Time.now
      current -= (current.sec + @window)
      current += 60
      current
    end
  end
end
