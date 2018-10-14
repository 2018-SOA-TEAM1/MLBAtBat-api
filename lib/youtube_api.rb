# frozen_string_literal: true

require 'http'
require_relative 'channel.rb'
require_relative 'video.rb'

module Youtube
  # Library for Youtube Data API
  class YoutubeAPI
    def initialize(yt_config)
      @yt_config = yt_config
      @api_key = @yt_config['API_KEY'].to_s
    end

    def channel(channel_id)
      channel_req_url = yt_api_path_get_channel(channel_id, @api_key)
      channel_data = call_yt_url(channel_req_url).parse
      Channel.new(channel_data)
    end

    def video(playlist_id)
      videos_req_url = yt_api_path_get_videos(playlist_id, @api_key)
      videos_data = call_yt_url(videos_req_url).parse
      Video.new(videos_data)
    end

    def yt_api_path_get_channel(channel_id, api_key)
      'https://www.googleapis.com/youtube/v3/channels?' \
      'part=contentDetails&' \
      'id=' + channel_id.to_s + '&' \
      'key=' + api_key
    end

    def yt_api_path_get_videos(playlist_id, api_key)
      'https://www.googleapis.com/youtube/v3/playlistItems?' \
      'playlistId=' + playlist_id.to_s + '&' \
      'part=contentDetails,snippet' + '&' \
      'maxResults=3' + '&' \
      'key=' + api_key
    end

    def call_yt_url(url)
      HTTP.get(url)
    end
  end
end
