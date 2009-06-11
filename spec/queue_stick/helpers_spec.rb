require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::Helpers do
  before(:each) do
    extend QueueStick::Helpers
  end

  describe "readable_name" do
    it "should capitalize and remove underscores" do
      name = readable_name(:messages_processed)
      name.should == 'Messages processed'
    end
  end

  describe "h" do
    it "should remove < and >" do
      result = h("VideoTranscoder<#0x8383299f>")
      result.should_not =~ /</
      result.should_not =~ />/
    end
  end

  describe "time_ago_or_time_stamp" do
    before(:all) do
      @to_time = Time.now
    end

    it "should handle minutes ago" do
      result = time_ago_or_time_stamp(@to_time - (5 * 60), @to_time)
      result.should == "5 minutes ago"
    end

    it "should handle hours ago" do
      result = time_ago_or_time_stamp(@to_time - (70 * 60), @to_time)
      result.should == "1 hour ago"
    end

    it "should handle multiple hours ago" do
      result = time_ago_or_time_stamp(@to_time - (110 * 60), @to_time)
      result.should == "2 hours ago"
    end

    it "should handle days ago" do
      result = time_ago_or_time_stamp(@to_time - (1500 * 60), @to_time)
      result.should == "1 day ago"
    end

    it "should handle 1.5 - 2 days ago" do
      result = time_ago_or_time_stamp(@to_time - (2180 * 60), @to_time)
      result.should == "2 days ago"
    end
  end

  describe "truncate" do
    it "should not put ... after a string that is less than max length" do
      result = truncate('string', 20)
      result.should == 'string'
    end

    it "should truncate a string that is more than max length" do
      result = truncate('string', 5)
      result.should == 'strin...'
    end
  end
end
