require 'rubygems'

module QueueStick
  class WebServer < Sinatra::Application
    set :environment, ($SINATRA_ENV ? $SINATRA_ENV : 'production')
    set :public, File.expand_path(File.dirname(__FILE__) + '/../../public')
    set :views, File.expand_path(File.dirname(__FILE__) + '/views')
    enable :raise_errors
    enable :static
    disable :logging

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
      # TODO(dbalatero): refactor all this shit
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

      # Pull out the error messages per thread.
      @errors = []
      @workers.each do |worker|
        @errors += worker.errors
      end
      @errors.sort! { |a, b| a.timestamp <=> b.timestamp }
      @errors.reverse!

      erb :index
    end

    get '/ping' do
      ''
    end
  end
end
