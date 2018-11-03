# frozen_string_literal: true

module MLBAtBat
  module Entity
    # Store information about videos from channel's playlist
    class LiveGame < Dry::Struct
      include Dry::Types.module

      attribute :id,                   Integer.optional
      attribute :game_pk,              Strict::Integer
      attribute :date,                 Strict::String
      attribute :current_hitter_name,  Strict::String
      attribute :detailed_state,       Strict::String
      attribute :home_team_runs,       Strict::Integer
      attribute :home_team_hits,       Strict::Integer
      attribute :home_team_errors,     Strict::Integer
      attribute :away_team_runs,       Strict::Integer
      attribute :away_team_hits,       Strict::Integer
      attribute :away_team_errors,     Strict::Integer
    end
  end
end
