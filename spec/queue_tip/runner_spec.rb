require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueTip::Runner do
  describe "initialize" do
    before(:each) do
      @argv = ["--port", "8193"]
    end

    it "should receive an array of ARGV options" do
      lambda {
        QueueTip::Runner.new(@argv) 
      }.should_not raise_error
    end

    it "should take an optional IO stream to write out messages to" do
      lambda {
        QueueTip::Runner.new(@argv, STDOUT)
      }.should_not raise_error
    end

    it "should raise an error if it doesn't receive a valid port from argv" do
      lambda {
        QueueTip::Runner.new([])
      }.should raise_error(QueueTip::Runner::MissingPortError)
    end

    it "should not raise a MissingPortError if the web server is disabled" do
      lambda {
        QueueTip::Runner.new(['--disable-web-server'])
      }.should_not raise_error(QueueTip::Runner::MissingPortError)
    end
  end
end
