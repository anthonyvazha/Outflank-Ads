module TimeHelper
    def time_since_creation(timestamp)
        # Convert string to Time object if it's a string
        timestamp = Time.parse(timestamp) if timestamp.is_a?(String)
      
        seconds_diff = (Time.now.utc - timestamp).to_i.abs
      
        hours = seconds_diff / 3600
        minutes = (seconds_diff - hours * 3600) / 60
        seconds = seconds_diff - hours * 3600 - minutes * 60
      
        if hours > 0
          "Initiated #{hours}h #{minutes}m #{seconds}s ago"
        elsif minutes > 0
          "Initiated #{minutes}m #{seconds}s ago"
        else
          "Initiated #{seconds}s ago"
        end
      end
      
  end