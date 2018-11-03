# frozen_string_literal: true

require 'sequel'

module MLBAtBat
  module Database
    # Object-Relational Mapper for schedules
    class ScheduleOrm < Sequel::Model(:schedules)
      one_to_one    :game,
                    class: :'MLBAtBat::Database::GameOrm',
                    key: :game_pk

      plugin :timestamps, update_on_create: true

    #   def self.find_or_create(member_info)
    #     first(username: member_info[:username]) || create(member_info)
    #   end
    end
  end
end
