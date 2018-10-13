module Youtube
  class Channel
    def initialize(channel_data)
      @channel_data = channel_data
    end

    def get_first_playlist_id
      @channel_data['items'][0]['contentDetails']['relatedPlaylists']['uploads']
    end
  end
end
