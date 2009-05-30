require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::MockWorker do
  describe "get_message_from_queue" do
    it "should always return the same message" do
      worker = QueueTip::MockWorker.new
      5.times do
        worker.get_message_from_queue.body.should == "foomessage"
      end
    end
  end

  describe "delete_message_from_queue" do
    it "should be a noop, and not raise an error" do
      worker = QueueTip::MockWorker.new
      lambda {
        worker.delete_message_from_queue(:foo)
      }.should_not raise_error
    end
  end
end
