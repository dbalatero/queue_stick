require 'rubygems'

module QueueStick
  class WebServer < Sinatra::Application
    set :environment, ($SINATRA_ENV ? $SINATRA_ENV : 'production')
    set :static, true
    set :public, File.expand_path(File.dirname(__FILE__) + '/../../public')
    set :views, File.expand_path(File.dirname(__FILE__) + '/views')
    set :raise_errors, true

    get '/' do
      @start_time = options.queue_runner.start_time
      @username = ENV['USER']
      @hostname = `hostname`.chomp! rescue nil
      @status = options.queue_runner.status.to_s.gsub(/_/, ' ')
      @workers = options.queue_runner.workers
      @port = options.queue_runner.port

      # Hash of
      #   :counter_name => {
      #     :thread_id => counter
      #   }
      #
      # TODO(dbalatero): refactor this shit
      @counters = Hash.new { |h, k| h[k] = {} }
      @total_counts = {}
      @workers.each do |worker|
        worker.class.counters.each do |counter_name|
          counter = worker.counter(counter_name)
          @counters[counter_name][:size] ||= counter.size
          @counters[counter_name][:names] ||= counter.names
          @counters[counter_name][:workers] ||= {}
          @counters[counter_name][:workers][worker.to_s] = counter.counts
        end
      end

      # Calculate the totals for the counters across threads
      @counters.each do |counter_name, info|
        info[:totals] = [].fill(0, 0, @counters[counter_name][:size])
        info[:workers].each do |worker_name, counts|
          counts.each_with_index do |count, i|
            info[:totals][i] += count
          end
        end
      end

      erb :index
    end

    get '/ping' do
      ''
    end
  end
end
