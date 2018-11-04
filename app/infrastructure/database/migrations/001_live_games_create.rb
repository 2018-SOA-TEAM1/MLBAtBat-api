# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games) do
      primary_key :id
      foreign_key :g_pk, :schedules, key: :game_pk

      String      :date
      String      :current_hitter_name
      String      :detailed_state
      String      :home_team_runs
      String      :home_team_hits
      String      :home_team_errors
      String      :away_team_runs
      String      :away_team_hits
      String      :away_team_errors

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
