require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::MockMessage do
  describe "body" do
    it "should return whatever is passed in" do
      message = QueueStick::MockMessage.new(:foo)
      message.body.should == :foo
    end
  end

  describe "id" do
    it "should return an random number" do
      message = QueueStick::MockMessage.new(:foo)
      message.id.should =~ /\d+/
    end
  end
end
