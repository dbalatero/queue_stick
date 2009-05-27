require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::Worker do
  describe "queue_name" do
    it "should set the global SQS queue name for any worker class" do
      QueueTip::Worker.queue_name(:my_queue_name)
      QueueTip::Worker.queue_name.should == :my_queue_name
    end

    it "should not overwrite each subclass' queue name" do
      class WorkerA < QueueTip::Worker; end
      class WorkerB < QueueTip::Worker; end

      WorkerA.queue_name(:worker_a_queue)
      WorkerB.queue_name(:worker_b_queue)

      WorkerA.queue_name.should == :worker_a_queue
      WorkerB.queue_name.should == :worker_b_queue
    end
  end

  describe "process" do
    it "should raise NotImplementedError at the base class" do
      lambda {
        worker = QueueTip::Worker.new
        worker.process("my message")
      }.should raise_error(NotImplementedError)
    end
  end

  describe "recover" do
    it "should raise NotImplementedError at the base class" do
      lambda {
        worker = QueueTip::Worker.new
        worker.recover
      }.should raise_error(NotImplementedError)
    end
  end
end
