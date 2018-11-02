# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:schedules) do
      primary_key :id

      Integer     :game_pk, unique: true
      String      :home_team_name
      String      :away_team_name

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
