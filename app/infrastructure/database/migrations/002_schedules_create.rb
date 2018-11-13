# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:schedules) do
      String      :date, primary_key: true
      Integer     :total_games

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
