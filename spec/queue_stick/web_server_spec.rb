require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe QueueStick::WebServer do
  def app
    QueueStick::WebServer
  end

  describe 'GET ping' do
    before(:each) do
      get '/ping'
    end

    it 'should return 200 OK' do
      last_response.should be_ok
    end

    it 'should have an empty body' do
      last_response.body.should be_empty
    end
  end
end
