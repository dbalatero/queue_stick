require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::WindowCounter do
  describe "initialize" do
    it "should take a name and time window in minutes for the counter" do
      lambda {
        QueueStick::WindowCounter.new(:my_counter, 5)
      }.should_not raise_error(ArgumentError)
    end

    it "should raise an error if a nil name is provided" do
      lambda {
        QueueStick::WindowCounter.new(nil, nil)
      }.should raise_error(ArgumentError)
    end

    it "should raise an error if a time window is not provided" do
      lambda {
        QueueStick::WindowCounter.new(:name, nil)
      }.should raise_error(ArgumentError)
    end
  end

  describe "name" do
    it "should return the correct name" do
      counter = QueueStick::WindowCounter.new(:test, 5)
      counter.name.should == :test
    end
  end

  describe "count" do
    it "should be zero at construction" do
      counter = QueueStick::WindowCounter.new(:test, 5)
      counter.count.should == 0
    end

    # see lighthouse ticket #11
    it "should not flip the count back to 0 randomly with multiple threads contending" do
      counter = QueueStick::WindowCounter.new(:test, 1)
      threads = []

      # 16 increments, 4 threads
      4.times do
        threads << Thread.new(counter) do |c|
          4.times do
            c.count
            c.increment!
            c.count
          end
        end
      end
      threads.each { |thread| thread.join }

      counter.count.should == 16
    end
  end

  describe "internal memory management" do
    it "should expire old timestamps when they get too big" do
      counter = QueueStick::WindowCounter.new(:test, 5)

      current_min = 30
      5.times do
        Time.stub!(:now).
          and_return(Time.mktime(2009, 5, 18, 22, current_min, 0, 0))
        counter.increment!
        current_min += 1
      end

      # No expiry yet.
      counter.tracked_minutes.should == 5

      5.times do
        Time.stub!(:now).
          and_return(Time.mktime(2009, 5, 18, 22, current_min, 0, 0))
        counter.increment!
        current_min += 1
      end

      # Should have expired some values, since we have tracked
      # double the minutes of 
      counter.tracked_minutes.should < 10
    end
  end

  describe "increment!" do
    before(:each) do
      @counter = QueueStick::WindowCounter.new(:test, 3)
    end

    it "should increment the counter by one, default" do
      lambda {
        @counter.increment!
      }.should change(@counter, :count).by(1)
    end

    it "should increment the counter by the amount given" do
      lambda {
        @counter.increment!(10)
      }.should change(@counter, :count).by(10)
    end

    it "should only maintain a count for the last X minutes" do
      Time.stub!(:now).
        and_return(Time.mktime(2009, 5, 18, 22, 30, 0, 0))
      @counter.increment!(5)
      @counter.count.should == 5

      Time.stub!(:now).
        and_return(Time.mktime(2009, 5, 18, 22, 31, 0, 0))
      @counter.increment!(3)
      @counter.count.should == 8

      Time.stub!(:now).
        and_return(Time.mktime(2009, 5, 18, 22, 33, 30, 0))
      @counter.count.should == 3
      
      @counter.increment!(10)
      @counter.count.should == 13
      @counter.increment!(20)
      @counter.count.should == 33

      Time.stub!(:now).
        and_return(Time.mktime(2009, 5, 18, 22, 37, 31, 0))
      @counter.count.should == 0
    end
  end
end
