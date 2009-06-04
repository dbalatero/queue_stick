require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::SQSMessage do
  before(:each) do
    @raw_message = mock
    methods = {
      :id => "12345678904GEZX9746N|0N9ED344VK5Z3SV1DTM0|1RVYH4X3TJ0987654321",
      :body=>"message_1"
    }
    methods.each do |k, v|
      @raw_message.should_receive(k).any_number_of_times.and_return(v)
    end
  end

  it "should be a subclass of Message" do
    message = QueueStick::SQSMessage.new(@raw_message)
    message.should be_a_kind_of(QueueStick::Message)
  end

  describe "id" do
    it "should return the ID from the raw message" do
      message = QueueStick::SQSMessage.new(@raw_message)
      message.id.should == "12345678904GEZX9746N|0N9ED344VK5Z3SV1DTM0|1RVYH4X3TJ0987654321"
    end
  end

  describe "body" do
    it "should return the body from the raw message" do
      message = QueueStick::SQSMessage.new(@raw_message)
      message.body.should == "message_1"
    end
  end
end
