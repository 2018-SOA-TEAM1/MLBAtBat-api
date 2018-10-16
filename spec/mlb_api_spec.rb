require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/mlb_api.rb'

describe 'Tests MLBAtBat libiary' do
  CORRECT = YAML.safe_load(File.read('./fixtures/mlb_results.yml'))
  RESPONSE = YAML.load(File.read('./fixtures/mlb_response.yml'))

  describe 'Schedule information' do
    it 'HAPPY: shoud provide correct game schedule information' do
      schedule = MLBAtBat::MLBAPI.new.schedule
      _(schedule.game_date).must_equal CORRECT['date']
      _(schedule.game_pk).must_equal CORRECT['game_pk']
    end
  end

  describe 'Live game information' do
    before do
      @schedule = MLBAtBat::MLBAPI.new.schedule
    end

    it 'HAPPY: shoud provide correct game state' do
      _(@schedule.game_detailed_state).must_equal CORRECT['detailed_state']
    end

    it 'HAPPY: shoud provide correct hitter name' do
      _(@schedule.current_hitter_name).must_equal CORRECT['current_player']
    end

    it 'SAD: shoud raise exception if given wrong gamePk' do
      proc do
        @schedule.game_detailed_state('600000')
      end.must_raise MLBAtBat::MLBAPI::Errors::NotFound
    end
  end
end
