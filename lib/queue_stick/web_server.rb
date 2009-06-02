require 'rubygems'
require 'sinatra/base'

module QueueStick
  class WebServer < Sinatra::Application
    set :environment, 'production'
    set :views, File.expand_path(File.dirname(__FILE__) + '/views')

    get '/' do
      erb :index
    end

    get '/ping' do
      ''
    end
  end
end
