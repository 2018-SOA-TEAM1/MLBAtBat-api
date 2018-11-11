require 'http'
require 'yaml'
require_relative './init.rb'

NON_EXIST_PK = '600000'
GAME_DATE = '07/17/2018'
GAME_PK = '530856'
SPORT_ID = 1

# schedule = MLBAtBat::MLB::ScheduleMapper
# .new
# .get_schedule(SPORT_ID, GAME_DATE)

# # branch domain
# pk = schedule.pk
whole_game = MLBAtBat::Mapper::WholeGame.new.get_whole_game(GAME_PK)

