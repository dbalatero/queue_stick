require 'rubygems'
require 'sinatra/base'

module QueueStick
  class WebServer < Sinatra::Application
    get '/ping' do
      ''
    end
  end
end
