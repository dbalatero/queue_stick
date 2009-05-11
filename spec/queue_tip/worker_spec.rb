require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::Worker do
  describe "queue_name" do
    it "should set the global SQS queue name for any worker class" do
      QueueTip::Worker.queue_name(:my_queue_name)
      QueueTip::Worker.queue_name.should == :my_queue_name
    end
  end
end
