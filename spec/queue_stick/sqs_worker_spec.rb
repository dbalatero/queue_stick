require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::SQSWorker do
  describe "instance methods for a worker" do
    before(:each) do
      QueueStick::SQSWorker.queue_name(:my_test_queue)
      
      @queue = mock('sqs_queue', :null_object => true)
      @sqs = mock('sqs_gen2', :null_object => true)
      @sqs.should_receive(:queue).with('my_test_queue', true).and_return(@queue)
      RightAws::SqsGen2.should_receive(:new).and_return(@sqs)
      @worker = QueueStick::SQSWorker.new
    end

    describe "delete_message_from_queue" do
      it "should call delete on the SQS message" do
        mock_raw = mock
        mock_raw.should_receive(:delete).and_return(true)
        message = QueueStick::MockMessage.new(:foo)
        message.should_receive(:raw_message).and_return(mock_raw)

        @worker.delete_message_from_queue(message)
      end
    end

    describe "get_message_from_queue" do
      it "should return an SQSMessage" do
        @queue.should_receive(:pop).and_return(:foo)
        message = @worker.get_message_from_queue
        message.should be_a_kind_of(QueueStick::Message)
      end

      it "should return nil if the queue is empty" do
        @queue.should_receive(:pop).and_return(nil)
        message = @worker.get_message_from_queue
        message.should be_nil
      end

      it "should return a message with the correct parameters" do
        message = mock
        message.should_receive(:id).and_return("5030")
        message.should_receive(:body).and_return("my message")
        @queue.should_receive(:pop).and_return(message)

        msg = @worker.get_message_from_queue
        msg.should_not be_nil
        msg.id.should == "5030"
        msg.body.should == "my message"
      end
    end
  end

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

  describe "aws_access_key_id" do
    it "should set the AWS access key for any worker class" do
      QueueStick::SQSWorker.aws_access_key_id('foo3')
      QueueStick::SQSWorker.aws_access_key_id.should == 'foo3'
    end

    it "should not overwrite each subclass' queue name" do
      class WorkerA < QueueStick::SQSWorker; end
      class WorkerB < QueueStick::SQSWorker; end

      WorkerA.aws_access_key_id('foo1')
      WorkerB.aws_access_key_id('foo2')
      WorkerA.aws_access_key_id.should == 'foo1'
      WorkerB.aws_access_key_id.should == 'foo2'
    end
  end

  describe "aws_secret_access_key" do
    it "should set the AWS access key for any worker class" do
      QueueStick::SQSWorker.aws_secret_access_key('foo3')
      QueueStick::SQSWorker.aws_secret_access_key.should == 'foo3'
    end

    it "should not overwrite each subclass' queue name" do
      class WorkerA < QueueStick::SQSWorker; end
      class WorkerB < QueueStick::SQSWorker; end

      WorkerA.aws_secret_access_key('foo1')
      WorkerB.aws_secret_access_key('foo2')
      WorkerA.aws_secret_access_key.should == 'foo1'
      WorkerB.aws_secret_access_key.should == 'foo2'
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
