require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::MockMessage do
  describe "body" do
    it "should return whatever is passed in" do
      message = QueueTip::MockMessage.new(:foo)
      message.body.should == :foo
    end
  end
end
