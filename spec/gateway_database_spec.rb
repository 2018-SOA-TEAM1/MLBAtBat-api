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
      
      schedule = MLBAtBat::MLB::ScheduleMapper
      .new
      .get_schedule(SPORT_ID, GAME_DATE)
      rebuilt = MLBAtBat::Repository::For.entity(schedule).create(schedule)
 
      _(rebuilt.pk).must_equal(schedule.pk)
      _(rebuilt.home_team).must_equal(schedule.home_team)
      _(rebuilt.away_team).must_equal(schedule.away_team)
    end    

    it 'HAPPY: should be able to save mlb livegame data to database' do
      
      schedule = MLBAtBat::MLB::ScheduleMapper
      .new
      .get_schedule(SPORT_ID, GAME_DATE)
      game = schedule.live_game

      rebuilt = MLBAtBat::Repository::For.entity(schedule).create(schedule)
      rebuilt_game = rebuilt.live_game

      _(rebuilt_game.date).must_equal(game.date)
      _(rebuilt_game.detailed_state).must_equal(game.detailed_state)
      _(rebuilt_game.home_team_runs).must_equal(game.home_team_runs)
    end    
  end



end
