# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../children/inning.rb'
require_relative '../children/player.rb'
require_relative '../children/gcm.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class WholeGame < Dry::Struct
      include Dry::Types.module

      attribute :game_pk,                Strict::Integer
      attribute :innings,                Strict::Array.of(Inning)
      # attribute :players,              Strict::Array.of(Player)
      attribute :gcms,                   Strict::Array.of(GameChangingMoment)
      attribute :home_runs,              Strict::Integer
      attribute :home_hits,              Strict::Integer
      attribute :home_errors,            Strict::Integer
      attribute :away_runs,              Strict::Integer
      attribute :away_hits,              Strict::Integer
      attribute :away_errors,            Strict::Integer
      attribute :home_team_name,         Strict::String
      attribute :away_team_name,         Strict::String
    end
  end
end
