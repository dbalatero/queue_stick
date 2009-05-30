require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::Message do
  describe "body" do
    it "should raise NotImplementedError" do
      message = QueueTip::Message.new(:foo)
      lambda {
        message.body
      }.should raise_error(NotImplementedError)
    end
  end

  describe "raw_message" do
    it "should return whatever was passed into the constructor" do
      message = QueueTip::Message.new(:foo)
      message.raw_message.should == :foo
    end
  end
end
