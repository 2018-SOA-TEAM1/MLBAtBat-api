# frozen_string_literal: true

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'
require_relative 'helpers/database_helper.rb'

describe 'Integration Tests of MLB API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_mlb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end
    
    it 'HAPPY: should be able to save mlb schedule data to database' do
      game_pk = MLBAtBat::MLB::ScheduleMapper
      .new
      .get_gamepk(GAME_DATE, SEARCH_TEAM_NAME)
      
      whole_game = MLBAtBat::Mapper::WholeGame.new.get_whole_game(game_pk)
      # _(whole_game.inngings_num).must_equal(10)
      # _(whole_game.live_play.homeScore).must_equal(8)
      # _(whole_game.live_play.awayScore).must_equal(6)
    end    


  end



end
