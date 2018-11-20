# frozen_string_literal: true

require_relative 'game.rb'

module Views
  # View for a single game entity
  class Game
    def initialize(game, index = nil)
      @game = game
      @index = index
    end

    def index_str
      "game[#{@index}]"
    end

    def date
      @game.date
    end

    def home_team_name
      @game.home_team_name
    end

    def away_team_name
      @game.away_team_name
    end
  end
end
