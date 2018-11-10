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

# use geme_pk to get current game status
live_api_path = "v1.1/game/#{GAME_PK}/feed/live"
mlb_live_url = mlb_api_path(live_api_path)
mlb_response[mlb_live_url] = call_mlb_url(mlb_live_url)
live_data = mlb_response[mlb_live_url].parse
live_data = live_data['liveData']

# linescore: record every inning's scores
plays = live_data['plays']
# puts plays.keys
allPlays = plays['allPlays']
play0 = allPlays[0]
result = play0['result']
about = play0['about']
atBatIndex = play0['atBatIndex']

puts result
puts about
puts atBatIndex