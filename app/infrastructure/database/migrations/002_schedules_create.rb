# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:schedules) do
      primary_key :id

      Integer     :pk, unique: true
      String      :home_team
      String      :away_team

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
