require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::SQSWorker do
  describe "counters" do
    it "should add default counters to any subclass of SQSWorker" do
      class WorkerSubclass < QueueStick::SQSWorker; end
      WorkerSubclass.counters.should have_at_least(1).thing
      WorkerSubclass.counters.should include(:messages_processed)
    end
  end

  describe "queue_name" do
    it "should set the global SQS queue name for any worker class" do
      QueueStick::SQSWorker.queue_name(:my_queue_name)
      QueueStick::SQSWorker.queue_name.should == :my_queue_name
    end

    it "should not overwrite each subclass' queue name" do
      class WorkerA < QueueStick::SQSWorker; end
      class WorkerB < QueueStick::SQSWorker; end

      WorkerA.queue_name(:worker_a_queue)
      WorkerB.queue_name(:worker_b_queue)

      WorkerA.queue_name.should == :worker_a_queue
      WorkerB.queue_name.should == :worker_b_queue
    end
  end

  describe "visibility_timeout" do
    it "should set the global SQS visibility timeout for any worker class" do
      QueueStick::SQSWorker.visibility_timeout(600)
      QueueStick::SQSWorker.visibility_timeout.should == 600
    end

    it "should default to 60 seconds" do
      class BlankWorker < QueueStick::SQSWorker; end
      BlankWorker.visibility_timeout.should == 60
    end

    it "should not overwrite each subclass' visibility timeout" do
      class WorkerC < QueueStick::SQSWorker; end
      class WorkerD < QueueStick::SQSWorker; end

      WorkerC.visibility_timeout(600)
      WorkerD.visibility_timeout(15000)

      WorkerC.visibility_timeout.should == 600
      WorkerD.visibility_timeout.should == 15000
    end
  end
end
