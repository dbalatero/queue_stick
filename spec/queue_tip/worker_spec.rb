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
      @message = QueueTip::MockMessage.new("foo")
      @worker = RunLoopTestWorker.new
      @worker.should_receive(:get_message_from_queue).
        any_number_of_times.
        and_return(@message)
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

  describe "counter" do
    it "should define a counter that the class keeps track of" do
      class WorkerE < QueueTip::Worker
        counter :how_many_times_did_chewie_think_with_his_stomach
      end

      WorkerE.counters.should include(:how_many_times_did_chewie_think_with_his_stomach)
    end

    it "should always have a counter to keep track of number of messages processed" do
      QueueTip::Worker.counters.should include(:messages_processed)
      class WorkerF < QueueTip::Worker
      end
      WorkerF.counters.should include(:messages_processed)
    end

    it "should not add the same counter twice" do
      QueueTip::Worker.counter :c1
      QueueTip::Worker.counter :c1

      c1s = QueueTip::Worker.counters.select { |c| c == :c1 }
      c1s.should have(1).thing
    end
  end

  describe "delete_message_from_queue" do
    it "should raise a NotImplementedError" do
      lambda {
        QueueTip::Worker.new.delete_message_from_queue(nil)
      }.should raise_error(NotImplementedError)
    end
  end

  describe "get_message_from_queue" do
    it "should raise a NotImplementedError" do
      lambda {
        QueueTip::Worker.new.get_message_from_queue
      }.should raise_error(NotImplementedError)
    end
  end
end
