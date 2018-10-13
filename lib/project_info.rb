require 'http'
require 'yaml'

config = YAML.safe_load(File.read('../config/secrets.yml'))
channel_id = 'UCkELMMBdy4gPj6ooQwYJ-yg' # https://www.youtube.com/channel/UCkELMMBdy4gPj6ooQwYJ-yg

def yt_api_path_GetPlayList(channel_id, config)
  'https://www.googleapis.com/youtube/v3/channels?' \
  'part=contentDetails&' \
  'id=' + channel_id.to_s + '&' \
  'key=' + config['API_KEY'].to_s
end

def yt_api_path_GetVideos(playlist_id, config)
  'https://www.googleapis.com/youtube/v3/playlistItems?' \
  'playlistId=' + playlist_id.to_s + '&' \
  'part=contentDetails,snippet' + '&' \
  'maxResults=3' + '&' \
  'key=' + config['API_KEY'].to_s
end

def call_yt_url(url)
  HTTP.get(url)
end

yt_response = {}
yt_results = {}

project_url = yt_api_path_GetPlayList(channel_id, config)
playlist_response = call_yt_url(project_url)
project = playlist_response.parse
yt_results['first playlist'] = project['items'][0]['contentDetails']['relatedPlaylists']['uploads']

videos_url = yt_api_path_GetVideos(yt_results['first playlist'], config)
yt_response[videos_url] = call_yt_url(videos_url)
videos = yt_response[videos_url].parse
yt_results['first video'] = videos['items'][0]['snippet']

File.write('../spec/fixtures/yt_response.yml', yt_response.to_yaml)
File.write('../spec/fixtures/yt_results.yml', yt_results.to_yaml)
