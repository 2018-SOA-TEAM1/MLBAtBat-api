# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about channnel
    class WholeGame < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :date,                     Strict::String
      attribute :home_team,                Strict::String
      attribute :away_team,                Strict::String
      attribute :live_game,                LiveGame

    end
  end
end
