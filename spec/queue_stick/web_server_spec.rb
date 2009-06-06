require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::WebServer do
  def app
    QueueStick::WebServer
  end

  describe "GET /ping" do
    before(:all) do
      get '/ping'
    end

    it 'should return 200 OK' do
      last_response.should be_ok
    end

    it 'should have an empty body' do
      last_response.body.should be_empty
    end
  end

  describe "GET /" do
    before(:all) do
      runner = mock
      runner.should_receive(:start_time).and_return(Time.now)
      runner.should_receive(:status).and_return(:running)

      # half-life DM, son!
      runner.should_receive(:port).and_return(27015)

      workers = [QueueStick::MockWorker.new,
                 QueueStick::MockWorker.new,
                 QueueStick::MockWorker.new]
      runner.should_receive(:workers).and_return(workers)

      app.set :queue_runner, runner
      get '/'
    end

    it "should return 200 OK" do
      last_response.should be_ok
    end

    it "should have the person's username in the template" do
      last_response.body.should =~ /Job started by.*#{ENV['USER']}/
    end

    it "should put the runner status in the template" do
      last_response.body.should =~ /Current status:.*running/
    end

    it "should put the worker port in the template" do
      last_response.body.should =~ /port.*27015/
    end

    describe "messages_processed counter" do
      it "should have the messages_processed counter header" do
        last_response.body.should =~ /<h\d>Messages processed<\/h\d>/
      end
    end
  end
end
