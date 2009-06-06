module QueueStick
  module Helpers
    def readable_name(name)
      name.to_s.gsub!(/_/, ' ').capitalize!
    end
  
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
end

Sinatra.helpers(QueueStick::Helpers)
