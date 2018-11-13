# frozen_string_literal: true

require_relative 'livegame.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class Schedule < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :date,                     Strict::Integer
      attribute :total_games,              Strict::Integer
      attribute :live_games,               Strict::Array.of(LiveGame)

      # those don't want to store in database
      def to_attr_hash
        to_hash.reject { |key, _| %i[id live_games].include? key }
      end

      def find_team_name(team_name)
        live_games.each do |live_game|
          test_array = [live_game.home_team_name, live_game.away_team_name]
          return live_game if test_array.include?(team_name)
        end
      end
    end
  end
end
