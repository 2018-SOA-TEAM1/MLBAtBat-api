require 'http'
require 'yaml'

config = YAML.safe_load(File.read('../config/secrets.yml'))
channel_id = 'UCllMvuz1DIPIoqNnur7_Pig' # https://www.youtube.com/channel/UCllMvuz1DIPIoqNnur7_Pig

def gh_api_path(channel_id, config)
  'https://www.googleapis.com/youtube/v3/activities?' \
  'part=snippet,contentDetails&' \
  'channelId=' + channel_id.to_s + '&' \
  'key=' + config['API_KEY'].to_s + '&' \
  'maxResults=50'
end

def call_gh_url(url)
  HTTP.get(url)
end

gh_response = {}
gh_results = {}

project_url = gh_api_path(channel_id, config)
gh_response[project_url] = call_gh_url(project_url)
project = gh_response[project_url].parse

gh_results['page informations'] = project['pageInfo']

gh_results['first video'] = project['items'][0]

gh_results['last video'] = project['items'][49]


File.write('../spec/fixtures/gh_response.yml', gh_response.to_yaml)
File.write('../spec/fixtures/gh_results.yml', gh_results.to_yaml)
