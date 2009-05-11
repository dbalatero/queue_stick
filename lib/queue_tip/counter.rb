module QueueTip
  class Counter
    attr_accessor :name, :count

    def initialize(name, starting_value = 0)
      raise ArgumentError,
            'Name must not be nil!' if name.nil?
      @name = name
      @count = starting_value
    end

    def increment!(by = 1)
      @count += by
    end
  end
end
