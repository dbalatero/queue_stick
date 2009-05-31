require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::Runner do
  describe "initialize" do
    before(:each) do
      @argv = ["--port", "8193"]
    end

    it "should receive an array of ARGV options" do
      lambda {
        QueueStick::Runner.new(@argv) 
      }.should_not raise_error
    end

    it "should take an optional IO stream to write out messages to" do
      lambda {
        QueueStick::Runner.new(@argv, STDOUT)
      }.should_not raise_error
    end

    it "should raise an error if it doesn't receive a valid port from argv" do
      lambda {
        QueueStick::Runner.new([])
      }.should raise_error(QueueStick::Runner::MissingPortError)
    end

    it "should not raise a MissingPortError if the web server is disabled" do
      lambda {
        QueueStick::Runner.new(['--disable-web-server'])
      }.should_not raise_error(QueueStick::Runner::MissingPortError)
    end
  end
end
