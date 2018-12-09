# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'
require_relative '../helpers/vcr_helper.rb'
require_relative '../helpers/database_helper.rb'
require 'rack/test'

def app
  MLBAtBat::Api
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_mlb
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Search game route' do
    it 'should be able to store correct game and retrieve whole game info.' do
      MLBAtBat::Service::SearchGame.new.call(
        date: GAME_DATE, team_name: SEARCH_TEAM_NAME
      )

      game_date = GAME_DATE.split('/').join('_')
      team_name = SEARCH_TEAM_NAME.split(' ').join('_')
      post "/api/v1/games/#{game_date}/#{team_name}"
      _(last_response.status).must_equal 201
      search_game = JSON.parse last_response.body
      _(search_game['game_pk']).must_equal 530_779
      _(search_game['home_runs']).must_equal 6
      _(search_game['home_hits']).must_equal 10
      _(search_game['home_errors']).must_equal 0
      _(search_game['away_runs']).must_equal 5
      _(search_game['away_hits']).must_equal 8
      _(search_game['away_errors']).must_equal 1
      _(search_game['home_team_name']).must_equal 'Baltimore Orioles'
      _(search_game['away_team_name']).must_equal 'New York Yankees'
      _(search_game['innings'].count).must_equal 9
      _(search_game['gcms'].count).must_equal 3
    end

    it 'should be able to retrieve particular game from database' do
      MLBAtBat::Service::SearchGame.new.call(
        date: GAME_DATE, team_name: SEARCH_TEAM_NAME
      )

      game_date = GAME_DATE.split('/').join('_')
      team_name = SEARCH_TEAM_NAME.split(' ').join('_')
      get "/api/v1/games/#{game_date}/#{team_name}"
      _(last_response.status).must_equal 200
      live_game = JSON.parse last_response.body
      _(live_game['date']).must_equal 20_180_710
      _(live_game['game_pk']).must_equal 530_779
      _(live_game['current_hitter_name']).must_equal 'Jonathan Schoop'
      _(live_game['detailed_state']).must_equal 'Final'
      _(live_game['home_team_name']).must_equal 'Baltimore Orioles'
      _(live_game['away_team_name']).must_equal 'New York Yankees'
      _(live_game['home_team_runs']).must_equal 6
      _(live_game['home_team_hits']).must_equal 10
      _(live_game['home_team_errors']).must_equal 0
      _(live_game['away_team_runs']).must_equal 5
      _(live_game['away_team_hits']).must_equal 8
      _(live_game['away_team_errors']).must_equal 1
    end

    it 'should be report error for searching for non-exist game' do
      MLBAtBat::Service::SearchGame.new.call(
        date: GAME_DATE, team_name: SEARCH_TEAM_NAME
      )

      invalid_date = '07/32/2018'
      game_date = invalid_date.split('/').join('_')
      team_name = SEARCH_TEAM_NAME.split(' ').join('_')
      get "/api/v1/games/#{game_date}/#{team_name}"
      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_include 'not'
    end
  end

  describe 'Find game route' do
    it 'should be able to find 1st game in database' do
      MLBAtBat::Service::SearchGame.new.call(
        date: GAME_DATE, team_name: SEARCH_TEAM_NAME
      )

      get 'api/v1/games/first'
      _(last_response.status).must_equal 200

      first_game = JSON.parse last_response.body
      _(first_game['game_pk']).must_equal 530_779
      _(first_game['home_runs']).must_equal 6
      _(first_game['home_hits']).must_equal 10
      _(first_game['home_errors']).must_equal 0
      _(first_game['away_runs']).must_equal 5
      _(first_game['away_hits']).must_equal 8
      _(first_game['away_errors']).must_equal 1
      _(first_game['home_team_name']).must_equal 'Baltimore Orioles'
      _(first_game['away_team_name']).must_equal 'New York Yankees'
      _(first_game['innings'].count).must_equal 9
      _(first_game['gcms'].count).must_equal 3
    end

    it 'should report error if there is no data in database' do
      get 'api/v1/games/first'
      _(last_response.status).must_equal 404

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'database'
    end
  end

  describe 'Get all games' do
    it 'should successfully get all games in database' do
      MLBAtBat::Service::SearchGame.new.call(
        date: GAME_DATE, team_name: SEARCH_TEAM_NAME
      )

      get 'api/v1/games'
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      _(response['livegames'].count).must_equal 1
    end

    it 'should return empty lists if there is no game in database' do
      get 'api/v1/games'
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      livegames = response['livegames']
      _(livegames).must_be_kind_of Array
      _(livegames.count).must_equal 0
    end
  end
end
