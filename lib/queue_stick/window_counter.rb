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

      # Converted to seconds.
      @window = window * 60
      @count = 0

      @counts = []
      @timings = []
    end

    # TODO(dbalatero): break this up?
    def count
      to_delete = []
      sum = 0
      threshold = threshold_time
      
      @counts.each_index do |index|
        if @timings[index] < threshold
          to_delete << index
        else
          sum += @counts[index]
        end
      end

      to_delete.each do |index|
        @counts.delete_at(index)
        @timings.delete_at(index)
      end

      sum
    end

    def increment!(by = 1)
      current = Time.now
      current -= current.sec
      timing = @timings.last

      if timing and 
         self.class.times_have_same_minute?(current, timing)
        @counts[@counts.size - 1] += by
      else
        @counts << by
        @timings << current
      end
    end

    private
    def self.times_have_same_minute?(time1, time2)
      time1.to_i / 60 == time2.to_i / 60
    end

    def threshold_time
      current = Time.now
      current - (current.sec + @window) + 60
    end
  end
end
