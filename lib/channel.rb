# frozen_string_literal: true

module Youtube
  # Store information about channnel
  class Channel
    def initialize(channel_data)
      @channel_data = channel_data
    end

    def first_playlist_id
      @channel_data['items'][0]['contentDetails']['relatedPlaylists']['uploads']
    end
  end
end
