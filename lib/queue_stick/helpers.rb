module QueueStick
  module Helpers
    def readable_name(name)
      name.to_s.gsub!(/_/, ' ').capitalize!
    end
  
    def h(text)
      Rack::Utils.escape_html(text)
    end

    def truncate(string, max_length, suffix = '...')
      if string.length <= max_length
        string
      else
        string[0...max_length] << suffix
      end
    end

    # Taken from:
    # http://snippets.dzone.com/posts/show/6229
    def time_ago_or_time_stamp(from_time, to_time = Time.now, include_seconds = true, detail = false)
      from_time = from_time.to_time if from_time.respond_to?(:to_time)
      to_time = to_time.to_time if to_time.respond_to?(:to_time)
      distance_in_minutes = (((to_time - from_time).abs)/60).round
      distance_in_seconds = ((to_time - from_time).abs).round
      case distance_in_minutes
      when 0..1           then time = (distance_in_seconds < 60) ? "#{distance_in_seconds} seconds ago" : '1 minute ago'
      when 2..59          then time = "#{distance_in_minutes} minutes ago"
      when 60..90         then time = '1 hour ago'
      when 90..1440       then time = "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160     then time = '1 day ago' # 1-1.5 days
      when 2160..2880     then time = "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5-2 days
      else time = from_time.strftime("%a, %d %b %Y")
      end
      return time_stamp(from_time) if (detail && distance_in_minutes > 2880)
      return time
    end
  end
end

Sinatra.helpers(QueueStick::Helpers)
