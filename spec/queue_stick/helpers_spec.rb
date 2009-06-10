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
