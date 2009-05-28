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

  describe "visibility_timeout" do
    it "should set the global SQS visibility timeout for any worker class" do
      QueueTip::Worker.visibility_timeout(600)
      QueueTip::Worker.visibility_timeout.should == 600
    end

    it "should default to 60 seconds" do
      class BlankWorker < QueueTip::Worker; end
      BlankWorker.visibility_timeout.should == 60
    end

    it "should not overwrite each subclass' visibility timeout" do
      class WorkerC < QueueTip::Worker; end
      class WorkerD < QueueTip::Worker; end

      WorkerC.visibility_timeout(600)
      WorkerD.visibility_timeout(15000)

      WorkerC.visibility_timeout.should == 600
      WorkerD.visibility_timeout.should == 15000
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

  describe "run_loop" do
    class RunLoopTestWorker < QueueTip::Worker
    end

    before(:each) do
      @worker = RunLoopTestWorker.new
    end

    it "should not raise an error if #process raises an error/exception" do
      @worker.should_receive(:process).and_raise(Exception)
      @worker.should_receive(:recover).and_return(true)

      lambda {
        @worker.run_loop
      }.should_not raise_error
    end

    it "should not raise an error if both #process and #recover raise an error/exception" do
      @worker.should_receive(:process).and_raise(Exception)
      @worker.should_receive(:recover).and_raise(Exception)

      lambda {
        @worker.run_loop
      }.should_not raise_error
    end

    it "should call delete_message_from_queue if process succeeds" do
      @worker.should_receive(:process).and_return(true)
      @worker.should_receive(:delete_message_from_queue).and_return(true)
      @worker.run_loop
    end

    it "should not call delete_message_from_queue if process fails" do
      @worker.should_receive(:process).and_raise(Exception)
      @worker.should_receive(:recover).and_return(true)
      @worker.should_not_receive(:delete_message_from_queue)
      @worker.run_loop
    end

    it "should log errors when process fails" do
      @worker.should_receive(:process).and_raise(Exception)
      @worker.should_receive(:recover).and_return(true)
      @worker.run_loop

      @worker.errors.should have(1).thing
    end

    it "should not log any more errors than MAX_ERRORS" do
      @worker.should_receive(:process).at_least(:once).and_raise(Exception)
      @worker.should_receive(:recover).at_least(:once).and_return(true)

      (QueueTip::Worker::MAX_ERRORS*2).times { @worker.run_loop }
      @worker.errors.should have(QueueTip::Worker::MAX_ERRORS).things
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
