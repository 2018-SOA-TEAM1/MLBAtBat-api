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
      attribute :innings,                Strict::Array
      # attribute :players,              Strict::Array.of(Player)
      # attribute :gcms,                 Strict::Array.of(GameChangingMoment)

    end
  end
end
