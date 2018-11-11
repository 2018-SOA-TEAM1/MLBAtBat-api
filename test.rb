# frozen_string_literal: true

require 'http'
require 'yaml'

NON_EXIST_PK = '600000'
GAME_DATE = '07/17/2018'
GAME_PK = '530856'

def mlb_api_path(path)
  'https://statsapi.mlb.com/api/' + path
end

def call_mlb_url(url)
  HTTP.get(url)
end

mlb_response = {}
mlb_results = {}

live_api_path = "v1.1/game/#{GAME_PK}/feed/live"
mlb_live_url = mlb_api_path(live_api_path)
mlb_response[mlb_live_url] = call_mlb_url(mlb_live_url)
data = mlb_response[mlb_live_url].parse

#puts data.keys
liveData = data['liveData']['plays']['allPlays']
puts liveData[0]

