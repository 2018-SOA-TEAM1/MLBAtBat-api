# frozen_string_literal: true

require_relative 'livegame.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class Schedule < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :pk,                       Strict::Integer
      attribute :home_team,                Strict::String
      attribute :away_team,                Strict::String
      attribute :live_game,                LiveGame

      # those don't want to store in database
      def to_attr_hash
        to_hash.reject { |key, _| [:id, :live_game].include? key }
      end
    end
  end
end
