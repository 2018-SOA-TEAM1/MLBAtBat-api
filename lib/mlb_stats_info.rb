# frozen_string_literal: true

require 'http'
require 'yaml'

NON_EXIST_PK = '600000'

def mlb_api_path(path)
  'https://statsapi.mlb.com/api/' + path
end

def call_mlb_url(url)
  HTTP.get(url)
end

mlb_response = {}
mlb_results = {}

## HAPPY requests

# get schedule to retrieve game_pk
mlb_schedule_url = mlb_api_path('v1/schedule?sportId=1')
mlb_response[mlb_schedule_url] = call_mlb_url(mlb_schedule_url)
schedule = mlb_response[mlb_schedule_url].parse

mlb_results['date'] = schedule['dates'][0]['date']
mlb_results['game_pk'] = schedule['dates'][0]['games'][0]['gamePk']

# use geme_pk to get current game status
game_pk = mlb_results['game_pk']
live_api_path = "v1.1/game/#{game_pk}/feed/live"
mlb_live_url = mlb_api_path(live_api_path)
mlb_response[mlb_live_url] = call_mlb_url(mlb_live_url)
live_data = mlb_response[mlb_live_url].parse

mlb_results['detailed_state'] = live_data['gameData']['status']['detailedState']
mlb_results['current_player'] = live_data['liveData']['plays']['currentPlay'] \
                                          ['matchup']['batter']['fullName']

## BAD requests
bad_api_path = "v1.1/game/#{NON_EXIST_PK}/feed/live"
bad_live_url = mlb_api_path(bad_api_path)
mlb_response[bad_live_url] = call_mlb_url(bad_live_url)
mlb_response[bad_live_url].parse

File.write('../spec/fixtures/mlb_response.yml', mlb_response.to_yaml)
File.write('../spec/fixtures/mlb_results.yml', mlb_results.to_yaml)
