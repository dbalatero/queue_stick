module QueueStick
  class BlendedCounter
    attr_reader :name

    def initialize(name, *timings)
      @name = name
      @counters = [Counter.new("Total")]

      timings.each do |time|
        @counters << WindowCounter.new("#{time} mins", time) 
      end
    end

    def size
      @counters.size
    end

    def names
      @counters.map { |counter| counter.name }
    end

    def counts
      @counters.map { |counter| counter.count }
    end

    def increment!(by = 1)
      @counters.each { |counter| counter.increment!(by) }
      nil
    end
  end
end
