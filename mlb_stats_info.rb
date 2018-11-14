# frozen_string_literal: true

require 'http'
require 'yaml'

NON_EXIST_PK = '600000'
GAME_DATE = '07/10/2018'

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
mlb_schedule_url = mlb_api_path("v1/schedule?sportId=1&date=#{GAME_DATE}")
mlb_response[mlb_schedule_url] = call_mlb_url(mlb_schedule_url)
schedule = mlb_response[mlb_schedule_url].parse

mlb_results['date'] = schedule['dates'][0]['date']
mlb_results['total_games'] = schedule['dates'][0]['totalGames']

# use game_pk to get current games status
live_games = []
total_games = mlb_results['total_games']

(0...total_games).each do |game_idx|
  game_pk = schedule['dates'][0]['games'][game_idx]['gamePk']
  live_api_path = "v1.1/game/#{game_pk}/feed/live"
  mlb_live_url = mlb_api_path(live_api_path)
  mlb_response[mlb_live_url] = call_mlb_url(mlb_live_url)
  game = mlb_response[mlb_live_url].parse

  live_game = {}
  live_game['date'] = game['gameData']['datetime']['originalDate']
  live_game['detailed_state'] = game['gameData']['status']['detailedState']
  live_game['current_player'] = game['liveData']['plays']['currentPlay'] \
                                            ['matchup']['batter']['fullName']
  live_game['home_team_name'] = game['gameData']['teams']['home']['name']
  live_game['away_team_name'] = game['gameData']['teams']['away']['name']
  live_game['home_team_status'] = game['liveData']['linescore']['teams'] \
                                            ['home']
  live_game['away_team_status'] = game['liveData']['linescore']['teams'] \
                                            ['away']
  live_games << live_game
end

mlb_results['live_games'] = live_games

## BAD requests
bad_api_path = "v1.1/game/#{NON_EXIST_PK}/feed/live"
bad_live_url = mlb_api_path(bad_api_path)
mlb_response[bad_live_url] = call_mlb_url(bad_live_url)
mlb_response[bad_live_url].parse

File.write('spec/fixtures/mlb_response.yml', mlb_response.to_yaml)
File.write('spec/fixtures/mlb_results.yml', mlb_results.to_yaml)