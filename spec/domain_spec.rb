# frozen_string_literal: true

require_relative 'helpers/spec_helper.rb'
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

    it 'HAPPY: should be able to create gcm and have correct inning number' do
      game_pk = MLBAtBat::MLB::ScheduleMapper
        .new
        .get_gamepk(GAME_DATE, SEARCH_TEAM_NAME)

      whole_game = MLBAtBat::Mapper::WholeGame.new.get_whole_game(game_pk)

      whole_game.gcms.each do |gcm|
        _(gcm.event).must_equal('Home Run')
      end
      # igore inning 0 (empty)
      _(whole_game.innings.length - 1).must_equal(9)
      _(whole_game.home_runs).must_equal(CORRECT['live_games'][0] \
        ['home_team_status']['runs'])
      _(whole_game.away_runs).must_equal(CORRECT['live_games'][0] \
        ['away_team_status']['runs'])
      _(whole_game.home_team_name).must_equal(CORRECT['live_games'][0] \
        ['home_team_name'])
      _(whole_game.away_team_name).must_equal(CORRECT['live_games'][0] \
        ['away_team_name'])
    end
  end
end
