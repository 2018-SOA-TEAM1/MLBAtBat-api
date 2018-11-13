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
        .get_schedule(SPORT_ID, GAME_DATE)
    end

    it 'HAPPY: schedule should provide correct game date' do
      _(@schedule.date).must_equal CORRECT['date'] \
        .split('-').join('').to_i
    end

    it 'HAPPY: schedule should provide correct total game numbers' do
      _(@schedule.total_games).must_equal CORRECT['total_games']
    end
  end

  describe 'Live game information' do
    before do
      @schedule = MLBAtBat::MLB::ScheduleMapper.new
        .get_schedule(SPORT_ID, GAME_DATE)
      @live_games = @schedule.live_games
      @total_games = @schedule.total_games
    end

    it 'HAPPY: live game should provide correct game informations' do
      (0...@total_games).each do |game_idx|
        _(@live_games[game_idx].date).must_equal \
          CORRECT['live_games'][game_idx]['date'] \
          .split('-').join('').to_i

        _(@live_games[game_idx].detailed_state).must_equal \
          CORRECT['live_games'][game_idx]['detailed_state']

        _(@live_games[game_idx].current_hitter_name).must_equal \
          CORRECT['live_games'][game_idx]['current_player']

        _(@live_games[game_idx].home_team_name).must_equal \
          CORRECT['live_games'][game_idx]['home_team_name']

        _(@live_games[game_idx].away_team_name).must_equal \
          CORRECT['live_games'][game_idx]['away_team_name']

        _(@live_games[game_idx].home_team_runs).must_equal \
          CORRECT['live_games'][game_idx]['home_team_status']['runs']

        _(@live_games[game_idx].home_team_hits).must_equal \
          CORRECT['live_games'][game_idx]['home_team_status']['hits']

        _(@live_games[game_idx].home_team_errors).must_equal \
          CORRECT['live_games'][game_idx]['home_team_status']['errors']

        _(@live_games[game_idx].away_team_runs).must_equal \
          CORRECT['live_games'][game_idx]['away_team_status']['runs']

        _(@live_games[game_idx].away_team_hits).must_equal \
          CORRECT['live_games'][game_idx]['away_team_status']['hits']

        _(@live_games[game_idx].away_team_errors).must_equal \
          CORRECT['live_games'][game_idx]['away_team_status']['errors']
      end
    end

    it 'SAD: shoud raise exception if given wrong gamePk' do
      proc do
        @live_game = MLBAtBat::MLB::LiveGameMapper.new
          .live_game_info(WRONG_PK_ID)
      end.must_raise MLBAtBat::MLB::Api::Response::InternalServerError
    end
  end
end