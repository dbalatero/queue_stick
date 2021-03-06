require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::Runner do
  before(:each) do
    @argv = ["--port", "8193"]
    @io_stream = StringIO.new
  end

  describe "port" do
    it "should return the port that the web server is running on" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.port.should == 8193
    end

    it "should return nil when there is no web server running" do
      runner = QueueStick::Runner.new(['--disable-web-server'], @io_stream)
      runner.port.should be_nil
    end
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

  describe "booting?" do
    it "should be true if the status == :booting" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should_receive(:status).and_return(:booting)
      runner.should be_booting
    end
  end

  describe "running?" do
    it "should be true if the status == :running" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should_receive(:status).and_return(:running)
      runner.should be_running
    end
  end

  describe "shutting_down?" do
    it "should be true if the status == :shutting_down" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should_receive(:status).and_return(:shutting_down)
      runner.should be_shutting_down
    end
  end

  describe "status" do
    it "should be :booting on initialization" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.status.should == :booting
    end

    it "should be :running after booting" do
      runner = QueueStick::Runner.new(["--disable-web-server"], @io_stream)
      t = Thread.new(runner) do |r|
        r.run!(QueueStick::MockWorker)
      end

      # wait until it finishes booting up
      while runner.booting?
      end

      runner.status.should == :running
      t.kill
    end

    it "should be :shutting_down after an interrupt" do
      runner = QueueStick::Runner.new(["--disable-web-server"], @io_stream)
      t = Thread.new(runner) do |r|
        r.run!(QueueStick::MockWorker)
      end

      # Wait to get into a running state
      while !runner.running?
      end

      runner.shutdown!
      runner.status.should == :shutting_down
      t.kill
    end
  end

  describe "start_time" do
    it "should be set once and then frozen" do
      time = Time.now
      Time.should_receive(:now).and_return(time)

      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.start_time.should be_frozen
      runner.start_time.should == time
    end
  end

  describe "workers" do
    it "should respond to workers" do
      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should respond_to(:workers)
    end
  end

  describe "errors" do
    it "should return an aggregate of all the errors across all threads" do
      worker1 = mock
      worker1.should_receive(:errors).and_return([:w1e1, :w1e2, :w1e3])
      worker2 = mock
      worker2.should_receive(:errors).and_return([:w2e1, :w2e2])

      runner = QueueStick::Runner.new(@argv, @io_stream)
      runner.should_receive(:workers).and_return([worker1, worker2])
      errors = runner.errors

      errors.should have(5).things
      [:w1e1, :w1e2, :w1e3, :w2e1, :w2e2].each do |error|
        errors.should include(error)
      end
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
