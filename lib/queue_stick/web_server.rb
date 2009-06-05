require 'rubygems'
require 'sinatra/base'

module QueueStick
  class WebServer < Sinatra::Application
    set :environment, 'production'
    set :static, true
    set :public, File.expand_path(File.dirname(__FILE__) + '/../../public')
    set :views, File.expand_path(File.dirname(__FILE__) + '/views')

    get '/' do
      @start_time = options.queue_runner.start_time
      @username = ENV['USER']
      @hostname = `hostname`.chomp! rescue nil
      erb :index
    end

    get '/ping' do
      ''
    end
  end
end
