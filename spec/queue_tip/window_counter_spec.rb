require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::WindowCounter do
  describe "initialize" do
    it "should take a name and time window in minutes for the counter" do
      lambda {
        QueueTip::WindowCounter.new(:my_counter, 5)
      }.should_not raise_error(ArgumentError)
    end

    it "should raise an error if a nil name is provided" do
      lambda {
        QueueTip::WindowCounter.new(nil, nil)
      }.should raise_error(ArgumentError)
    end

    it "should raise an error if a time window is not provided" do
      lambda {
        QueueTip::WindowCounter.new(:name, nil)
      }.should raise_error(ArgumentError)
    end
  end

  describe "name" do
    it "should return the correct name" do
      counter = QueueTip::WindowCounter.new(:test, 5)
      counter.name.should == :test
    end
  end

  describe "count" do
    it "should be zero at construction" do
      counter = QueueTip::WindowCounter.new(:test, 5)
      counter.count.should == 0
    end
  end

  describe "increment!" do
    before(:each) do
      @counter = QueueTip::WindowCounter.new(:test, 3)
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
        and_return(Time.mktime(2009, 5, 18, 22, 36, 0, 0))
      @counter.count.should == 0
    end
  end
end
