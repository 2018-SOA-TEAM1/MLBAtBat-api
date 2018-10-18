require_relative 'spec_helper.rb'

describe 'Tests MLBAtBat libiary' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
  end

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end


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
