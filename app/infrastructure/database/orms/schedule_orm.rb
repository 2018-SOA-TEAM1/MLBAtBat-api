# frozen_string_literal: true

require 'sequel'

module MLBAtBat
  module Database
    # Object-Relational Mapper for schedules
    class ScheduleOrm < Sequel::Model(:schedules)
      one_to_many   :games,
                    class: :'MLBAtBat::Database::GameOrm',
                    key: :game_date

      plugin :timestamps, update_on_create: true
    end
  end
end
