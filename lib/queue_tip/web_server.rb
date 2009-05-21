require 'rubygems'
require 'sinatra/base'

module QueueTip
  class WebServer < Sinatra::Application
    get '/ping' do
      ''
    end
  end
end
