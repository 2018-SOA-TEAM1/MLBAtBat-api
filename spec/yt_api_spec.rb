require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/youtube_api.rb'

describe 'Tests CodePraise libiary' do
  YT_CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
  CORRECT = YAML.safe_load(File.read('./fixtures/yt_results.yml'))

  CHANNEL_ID = 'UCkELMMBdy4gPj6ooQwYJ-yg'.freeze

  describe 'Channel information' do
    it do 'HAPPY: shoud provide correct playlist id'
      youtube_api = Youtube::YoutubeAPI.new(YT_CONFIG)
      channel = youtube_api.channel(CHANNEL_ID)
      _(channel.first_playlist_id).must_equal CORRECT['first playlist']
    end
  end

  describe 'Video information' do
    before do
      @youtube_api = Youtube::YoutubeAPI.new(YT_CONFIG)
      channel = @youtube_api.channel(CHANNEL_ID)
      @playlist_id = channel.first_playlist_id
    end

    it do 'HAPPY: shoud provide correct first video title'
      videos = @youtube_api.video(@playlist_id)
      first_video = videos.first_video
      _(videos.first_video_title).must_equal CORRECT['first video']['title']
    end

    it do 'HAPPY: shoud provide correct first video id'
      videos = @youtube_api.video(@playlist_id)
      first_video = videos.first_video
      _(videos.first_video_id).must_equal CORRECT['first video']['resourceId']['videoId']
    end
  end
end
