# frozen_string_literal: true

require_relative 'game.rb'

module Views
  # View for game entities
  class GamesList
    def initialize(games)
      @games = games.map.with_index { |game, i| Game.new(game, i) }
    end

    def any?
      @games.any?
    end

    def each
      @games.each do |game|
        yield game
      end
    end
  end
end
