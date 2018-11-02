# frozen_string_literal: true

require_relative 'live_game.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class Schedule < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :game_date,                Strict::String
      attribute :game_pk,                  Strict::Integer
      attribute :home_team,                Strict::String
      attribute :away_team,                Strict::String
      attribute :live_game,                LiveGame
    end
  end
end
