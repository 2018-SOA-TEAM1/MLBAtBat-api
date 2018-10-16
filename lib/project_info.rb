require 'http'
require 'yaml'

GAME_PK = '563402'.freeze # gamePk can get from https://statsapi.mlb.com/api/v1/schedule?sportId=1

def mlb_api_path(game_pk)
  'https://statsapi.mlb.com/api/v1.1/game/' << game_pk << '/feed/live'
end

def call_mlb_url(url)
  HTTP.get(url)
end

mlb_response = {}
mlb_results = {}

mlb_live_url = mlb_api_path(GAME_PK)
mlb_response[mlb_live_url] = call_mlb_url(mlb_live_url)
live_data = mlb_response[mlb_live_url].parse

mlb_results['detailed_state'] = live_data['gameData']['status']['detailedState']
mlb_results['current_player'] = live_data['liveData']['plays']['currentPlay'] \
                                          ['matchup']['batter']['fullName']

File.write('../spec/fixtures/mlb_response.yml', mlb_response.to_yaml)
File.write('../spec/fixtures/mlb_results.yml', mlb_results.to_yaml)
