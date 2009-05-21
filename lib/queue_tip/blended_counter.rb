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
  end
end
