# frozen_string_literal: true

require_relative 'livegame.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class Schedule < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :date,                     Strict::String
      attribute :total_games,              Strict::Integer
      attribute :live_games,               Strict::Array.of(LiveGame)

      # those don't want to store in database
      def to_attr_hash
        to_hash.reject { |key, _| %i[id live_game].include? key }
      end
    end
  end
end
