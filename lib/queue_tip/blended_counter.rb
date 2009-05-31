module QueueStick
  class BlendedCounter
    attr_reader :name

    def initialize(name, *timings)
      @name = name
      @counters = [Counter.new("0")]

      timings.each do |time|
        @counters << WindowCounter.new("#{time}", time) 
      end
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
