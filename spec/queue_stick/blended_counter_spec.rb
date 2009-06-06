require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::BlendedCounter do
  describe "initialize" do
    it "should take a name for the counter" do
      lambda {
        QueueStick::BlendedCounter.new(:my_counter)
      }.should_not raise_error
    end

    it "should take a variable number of arguments for time" do
      lambda {
        QueueStick::BlendedCounter.new(:my_counter, 1, 2, 5)
        QueueStick::BlendedCounter.new(:my_counter, 1, 5, 10, 20)
      }.should_not raise_error
    end
  end

  describe "name" do
    it "should return the given name" do
      counter = QueueStick::BlendedCounter.new("my_name")
      counter.name.should == "my_name"
    end
  end

  describe "names" do
    it "should output human-readable names for the values it is tracking" do
      @counter = QueueStick::BlendedCounter.new(:my_counter, 5, 10, 15)
      @counter.names.should == ["Total", "5 mins", "10 mins", "15 mins"]
    end
  end

  describe "size" do
    it "should return the number of subcounters" do
      counter = QueueStick::BlendedCounter.new(:name, 5)
      counter.size.should == 2
    end
  end

  describe "counts" do
    before(:each) do
      @counter = QueueStick::BlendedCounter.new(:my_counter, 5, 10, 15)
    end

    it "should return 0 for all values initially" do
      @counter.counts.should == [0, 0, 0, 0]
    end
  end

  describe "increment!" do
    before(:each) do
      @counter = QueueStick::BlendedCounter.new(:my_counter, 5, 10, 15)
    end

    it "should increment each counter by the given amount" do
      @counter.increment!(10)
      @counter.counts.should == [10, 10, 10, 10]
    end

    it "should increment each counter by 1, by default" do
      @counter.increment!
      @counter.counts.should == [1, 1, 1, 1]
    end
  end
end
