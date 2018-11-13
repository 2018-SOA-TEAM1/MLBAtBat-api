# frozen_string_literal: true

module MLBAtBat
  module Entity
    # Store
    class LiveGame < Dry::Struct
      include Dry::Types.module

      attribute :id,                   Integer.optional
      attribute :date,                 Strict::String
      attribute :current_hitter_name,  Strict::String
      attribute :detailed_state,       Strict::String
      attribute :home_team_name,       Strict::String
      attribute :away_team_name,       Strict::String
      attribute :home_team_runs,       Strict::Integer
      attribute :home_team_hits,       Strict::Integer
      attribute :home_team_errors,     Strict::Integer
      attribute :away_team_runs,       Strict::Integer
      attribute :away_team_hits,       Strict::Integer
      attribute :away_team_errors,     Strict::Integer

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
