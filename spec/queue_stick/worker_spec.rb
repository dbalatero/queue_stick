require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::Worker do
  describe "process" do
    it "should raise NotImplementedError at the base class" do
      lambda {
        worker = QueueStick::Worker.new
        worker.process("my message")
      }.should raise_error(NotImplementedError)
    end
  end

  describe "run_loop" do
    class RunLoopTestWorker < QueueStick::Worker
    end

    before(:each) do
      @message = QueueStick::MockMessage.new("foo")
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

    it "should put itself to sleep and return if there are no queue messages" do
      worker = QueueStick::MockWorker.new
      worker.should_receive(:get_message_from_queue).and_return(nil)
      worker.should_not_receive(:process)
      
      t = Thread.new(worker) do |w|
        w.run_loop
      end

      # wait for sleep
      while !t.stop?
      end

      t.status.should == 'sleep'
      t.kill
    end

    it "should automatically increment messages_processed on each loop" do
      worker = QueueStick::MockWorker.new
      worker.run_loop
      worker.counter(:messages_processed).counts[0].should == 1
      worker.run_loop
      worker.counter(:messages_processed).counts[0].should == 2
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

    it "should terminate after a run if the current thread's :shutdown variable is set" do
      worker = QueueStick::MockWorker.new
      thread = Thread.new do
        worker.run_loop while true
      end
      thread[:shutdown] = true

      thread.join
      thread.should_not be_alive
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

      (QueueStick::Worker::MAX_ERRORS*2).times { @worker.run_loop }
      @worker.errors.should have(QueueStick::Worker::MAX_ERRORS).things
    end
  end

  describe "counter" do
    it "should return a counter that has been defined on the class" do
      worker = QueueStick::Worker.new
      counter = worker.counter(:messages_processed)
      counter.should be_an_instance_of(QueueStick::BlendedCounter)
    end

    it "should not return a counter if it hasn't been defined for the class" do
      worker = QueueStick::Worker.new
      worker.counter(:not_a_counter).should be_nil
    end
  end

  describe "recover" do
    it "should raise NotImplementedError at the base class" do
      lambda {
        worker = QueueStick::Worker.new
        worker.recover
      }.should raise_error(NotImplementedError)
    end
  end

  describe "self.counter" do
    it "should define a counter that the class keeps track of" do
      class WorkerE < QueueStick::Worker
        counter :how_many_times_did_chewie_think_with_his_stomach
      end

      WorkerE.counters.should include(:how_many_times_did_chewie_think_with_his_stomach)
    end

    it "should always have a counter to keep track of number of messages processed" do
      QueueStick::Worker.counters.should include(:messages_processed)
      class WorkerF < QueueStick::Worker
      end
      WorkerF.counters.should include(:messages_processed)
    end

    it "should not add the same counter twice" do
      QueueStick::Worker.counter :c1
      QueueStick::Worker.counter :c1

      c1s = QueueStick::Worker.counters.select { |c| c == :c1 }
      c1s.should have(1).thing
    end
  end

  describe "delete_message_from_queue" do
    it "should raise a NotImplementedError" do
      lambda {
        QueueStick::Worker.new.delete_message_from_queue(nil)
      }.should raise_error(NotImplementedError)
    end
  end

  describe "get_message_from_queue" do
    it "should raise a NotImplementedError" do
      lambda {
        QueueStick::Worker.new.get_message_from_queue
      }.should raise_error(NotImplementedError)
    end
  end
end
