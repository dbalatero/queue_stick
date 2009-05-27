module QueueTip
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
      @counters.map { |c| c.count }
    end

    def increment!(by = 1)
      @counters.each { |c| c.increment!(by) }
      nil
    end
  end
end
