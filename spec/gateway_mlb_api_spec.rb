# frozen_string_literal: true

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'

describe 'Tests MLBAtBat libiary' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_mlb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Schedule information' do
    before do
      @schedule = MLBAtBat::MLB::ScheduleMapper.new
                                               .get_schedule(SPORT_ID,
                                                             GAME_DATE)
    end

    it 'HAPPY: shoud provide correct game date' do
      _(@schedule.game_date).must_equal CORRECT['date']
    end

    it 'HAPPY: should provide correct game pk' do
      _(@schedule.game_pk).must_equal CORRECT['game_pk']
    end

    it 'HAPPY: should provide correct home team name' do
      _(@schedule.home_team).must_equal CORRECT['home_team']
    end

    it 'HAPPY: should provide correct away team name' do
      _(@schedule.away_team).must_equal CORRECT['away_team']
    end
  end

  describe 'Live game information' do
    before do
      @schedule = MLBAtBat::MLB::ScheduleMapper.new
                                               .get_schedule(SPORT_ID,
                                                             GAME_DATE)
      @live_game = @schedule.live_game
    end

    it 'HAPPY: shoud provide correct game state' do
      _(@live_game.detailed_state).must_equal CORRECT['detailed_state']
    end

    it 'HAPPY: shoud provide correct hitter name' do
      _(@live_game.current_hitter_name).must_equal CORRECT['current_player']
    end

    it 'HAPPY: shoud provide correct home team status' do
      _(@live_game.home_team_runs).must_equal CORRECT['home_team_status'] \
                                                     ['runs']
      _(@live_game.home_team_hits).must_equal CORRECT['home_team_status'] \
                                                     ['hits']
      _(@live_game.home_team_errors).must_equal CORRECT['home_team_status'] \
                                                       ['errors']
    end

    it 'HAPPY: shoud provide correct away team status' do
      _(@live_game.away_team_runs).must_equal CORRECT['away_team_status'] \
                                                     ['runs']
      _(@live_game.away_team_hits).must_equal CORRECT['away_team_status'] \
                                                     ['hits']
      _(@live_game.away_team_errors).must_equal CORRECT['away_team_status'] \
                                                       ['errors']
    end

    it 'HAPPY: shoud provide correct away team status' do
      _(@live_game.current_hitter_name).must_equal CORRECT['current_player']
    end

    it 'SAD: shoud raise exception if given wrong gamePk' do
      proc do
        @live_game = MLBAtBat::MLB::LiveGameMapper.new
                                                  .live_game_info(WRONG_PK_ID)
      end.must_raise MLBAtBat::MLB::Api::Response::InternalServerError
    end
  end
end
