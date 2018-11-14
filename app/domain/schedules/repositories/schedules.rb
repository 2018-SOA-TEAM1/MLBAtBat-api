# frozen_string_literal: true

require 'pry'

module MLBAtBat
  module Repository
    # Repository for Schedule Entities
    class Schedules
      # def self.all
      #   Database::ScheduleOrm.all.map do |db_schedule|
      #     rebuild_entity(db_schedule)
      #   end
      # end

      def self.create(entity, team_name = 'Null')
        # err_msg = '(Under development) Sorry: this date Game already exists'
        db_schedule = PersistProject.new(entity, team_name).call
        rebuild_entity(db_schedule)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Schedule.new(
          db_record.to_hash.merge(
            id: db_record.id,
            live_games: LiveGames.rebuild_many(db_record.games)
          )
        )
      end

      def self.find_date(date)
        # ex: 06/13/2018 -> 20180613
        date_split = date.split('/')
        temp_date = date_split[2] + date_split[0] + date_split[1]
        temp_date = temp_date.to_i
        db_record_schedule = Database::ScheduleOrm.find(date: temp_date)
        rebuild_entity(db_record_schedule)
      end

      # Helper class to persist schedule and its game to database
      class PersistProject
        def initialize(entity, team_name = 'Null')
          @entity = entity
          @team_name = team_name
        end

        def create_schedule
          Database::ScheduleOrm.unrestrict_primary_key
          Database::ScheduleOrm.find_or_create(@entity.to_attr_hash)
        end

        def call
          # should create schedule first and then game
          db_schhedule = create_schedule
          if @team_name != 'Null'
            game_now = @entity.find_team_name(@team_name)
            LiveGames.db_find_or_create(game_now)
          else
            @entity.live_games.each do |live_game|
              LiveGames.db_find_or_create(live_game)
            end
          end
          db_schhedule
        end
      end
    end
  end
end