require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::Runner do
  before(:each) do
    @argv = ["--port", "8193"]
    @io_stream = StringIO.new
  end

  describe "initialize" do
    it "should receive an array of ARGV options and a worker class" do
      lambda {
        QueueStick::Runner.new(@argv, @io_stream)
      }.should_not raise_error
    end

    it "should take an optional IO stream to write out messages to" do
      lambda {
        QueueStick::Runner.new(@argv, @io_stream)
      }.should_not raise_error
    end

    it "should raise an error if it doesn't receive a valid port from argv" do
      lambda {
        QueueStick::Runner.new([], @io_stream)
      }.should raise_error(QueueStick::Runner::MissingPortError)
    end

    it "should not raise a MissingPortError if the web server is disabled" do
      lambda {
        QueueStick::Runner.new(['--disable-web-server'], @io_stream)
      }.should_not raise_error(QueueStick::Runner::MissingPortError)
    end
  end

  describe "run!" do
    it "should initialize the workers" do
      runner = QueueStick::Runner.new(['--disable-web-server', '--port', '1234'], @io_stream)
      runner.should_receive(:initialize_workers!).with(QueueStick::Worker)
      runner.should_receive(:start_workers!)
      runner.run!(QueueStick::Worker)
    end

    it "should start up the web server if it isn't disabled" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should_receive(:start_web_server!)
      runner.should_receive(:start_workers!)
      runner.run!(QueueStick::Worker)
    end

    it "should start up workers" do
      mock_worker = mock('worker', :null_object => true)
      mock_worker.should_receive(:run_loop).and_raise(ArgumentError)
      QueueStick::Worker.should_receive(:new).at_least(:once).and_return(mock_worker)

      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should_receive(:start_web_server!)
      lambda {
        runner.run!(QueueStick::Worker)
      }.should raise_error(ArgumentError)
    end
  end
end
