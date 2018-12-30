# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'
require_relative '../helpers/vcr_helper.rb'
require_relative '../helpers/database_helper.rb'

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
        .get_schedule(SPORT_ID, GAME_DATE, GAME_PK)
      rebuilt = MLBAtBat::Repository::For.entity(schedule).create(schedule)

      _(rebuilt.date).must_equal(schedule.date)
      _(rebuilt.total_games).must_equal(schedule.total_games)
    end

    it 'HAPPY: should be able to save mlb livegame data to database' do
      schedule = MLBAtBat::MLB::ScheduleMapper
        .new
        .get_schedule(SPORT_ID, GAME_DATE, GAME_PK)
      game = schedule.find_team_name(SEARCH_TEAM_NAME)

      rebuilt_schedule = MLBAtBat::Repository::For.entity(schedule)
        .create(schedule)
      rebuilt_game = rebuilt_schedule.find_team_name(SEARCH_TEAM_NAME)

      _(rebuilt_game.date).must_equal(game.date)
      _(rebuilt_game.detailed_state).must_equal(game.detailed_state)
      _(rebuilt_game.home_team_runs).must_equal(game.home_team_runs)
      _(rebuilt_game.game_pk).must_equal(game.game_pk)
    end
  end
end
