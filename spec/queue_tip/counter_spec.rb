require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::Counter do
  describe "initialize" do
    it "should take a name for the counter" do
      lambda {
        QueueTip::Counter.new(:my_counter)
      }.should_not raise_error
    end

    it "should not allow nil to be passed in for name" do
      lambda {
        QueueTip::Counter.new(nil)
      }.should raise_error(ArgumentError)
    end

    it "should take a starting total" do
      lambda {
        QueueTip::Counter.new(:my_counter, 50)
      }.should_not raise_error
    end
  end

  describe "name" do
    it "should return the name given to the constructor" do
      counter = QueueTip::Counter.new(:my_counter)
      counter.name.should == :my_counter
    end
  end
  
  describe "count" do
    before(:each) do
      @counter = QueueTip::Counter.new(:my_counter)
    end

    it "should be zero if not specified at construction" do
      @counter.count.should == 0
    end

    it "should be equal to the specified construction value if given" do
      counter = QueueTip::Counter.new(:my_counter, 50)
      counter.count.should == 50
    end
  end

  describe "increment!" do
    before(:each) do
      @counter = QueueTip::Counter.new(:my_counter)
    end

    it "should increment the count on a counter by one as the default" do
      lambda {
        @counter.increment!
      }.should change(@counter, :count).by(1)
    end

    it "should increment the count on a counter by the number provided" do
      lambda { 
        @counter.increment!(50) 
      }.should change(@counter, :count).by(50)
    end
  end
end
