# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:games) do
      primary_key :id
      foreign_key :game_date, :schedules, key: :date

      Integer     :game_pk
      String      :current_hitter_name
      String      :detailed_state
      String      :home_team_name
      String      :away_team_name
      Integer     :home_team_runs
      Integer     :home_team_hits
      Integer     :home_team_errors
      Integer     :away_team_runs
      Integer     :away_team_hits
      Integer     :away_team_errors

      DateTime :created_at
      DateTime :updated_at
    end
  end
end