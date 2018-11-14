# frozen_string_literal: true

require 'sequel'

module MLBAtBat
  module Database
    # Object-Relational Mapper for games
    class GameOrm < Sequel::Model(:games)
      many_to_one   :schedule,
                    class: :'MLBAtBat::Database::ScheduleOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end