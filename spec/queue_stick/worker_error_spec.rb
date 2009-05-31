require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::WorkerError do
  describe "message_id" do
    it "should return the passed in message ID" do
      error = QueueStick::WorkerError.new(:my_id)
      error.message_id.should == :my_id
    end
  end

  describe "timestamp" do
    it "should save a timestamp that the error was created at" do
      current_time = Time.now
      Time.should_receive(:now).and_return(current_time)

      error = QueueStick::WorkerError.new(:my_id)
      error.timestamp.should == current_time
    end
  end

  describe "exceptions" do
    before(:each) do
      @error = QueueStick::WorkerError.new(:my_id)
    end

    it "should by default be empty" do
      @error.exceptions.should be_empty
    end
  end
end
