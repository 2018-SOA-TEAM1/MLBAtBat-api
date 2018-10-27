# frozen_string_literal: true

require_relative 'live_game.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class Schedule < Dry::Struct
      include Dry::Types.module

      attribute :game_date,                Strict::String
      attribute :game_pk,                  Strict::Integer
      attribute :live_game,                LiveGame
    end
  end
end
