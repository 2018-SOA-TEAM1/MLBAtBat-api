# frozen_string_literal: true

require_relative 'inning.rb'
require_relative 'gcm.rb'

module Views
  # View for a single whole_game entity
  class WholeGame
    def initialize(whole_game)
      @whole_game = whole_game
      @innings = whole_game.innings.map.with_index do |inning, i|
        Inning.new(inning, i)
      end
      @gcms = whole_game.gcms.map do |gcm|
        GameChangingMoment.new(gcm)
      end
    end

    def innings_num
      @whole_game.innings.length - 1
    end

    def each_inning
      @innings.each do |inning|
        yield inning
      end
    end

    def each_gcm
      @gcms.each do |gcm|
        yield gcm
      end
    end

    def date
      @whole_game.date
    end

    def home_team_name
      @whole_game.home_team_name
    end

    def away_team_name
      @whole_game.away_team_name
    end

    def home_runs
      @whole_game.home_runs
    end

    def home_hits
      @whole_game.home_hits
    end

    def home_errors
      @whole_game.home_errors
    end

    def away_runs
      @whole_game.away_runs
    end

    def away_hits
      @whole_game.away_hits
    end

    def away_errors
      @whole_game.away_errors
    end
  end
end
