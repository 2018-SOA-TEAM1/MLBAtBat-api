# frozen_string_literal: true

require 'sequel'

module MLBAtBat
  module Database
    # Object-Relational Mapper for games
    class GameOrm < Sequel::Model(:games)
      many_to_one   :schedule,
                    class: :'MLBAtBat::Database::ScheduleOrm',
                    key: :pk

      plugin :timestamps, update_on_create: true

    #   def self.find_or_create(member_info)
    #     first(username: member_info[:username]) || create(member_info)
    #   end
    end
  end
end
