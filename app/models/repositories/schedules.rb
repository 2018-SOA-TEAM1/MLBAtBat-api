# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for Schedule Entities
    class Schedules
      def self.all
        Database::ScheduleOrm.all.map do |db_schedule|
          rebuild_entity(db_schedule)
        end
      end

      def self.create(entity)
        err_msg = '(Under development) Sorry: this date Game already exists'
        # raise err_msg if find(entity)
        
        db_schedule = PersistProject.new(entity).call
        rebuild_entity(db_schedule)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Schedule.new(
          db_record.to_hash.merge(
            id: db_record.id,
            live_games: LiveGames.rebuild_many(db_record.games),
          )
        )
      end

      def self.find(entity)
        find_pk(entity.pk)
      end

      def self.find_team_name(game_pk)
        db_record = Database::ScheduleOrm.first(game_pk: game_pk)
        return db_record if db_record
        rebuild_entity(db_record)
      end

      def self.find_date(date)
        # ex: 06/13/2018 -> 2018-06-13
        # correspond to database record's date format
        date_split = date.split('/')
        temp_date = date_split[2] + '-' + date_split[0] + '-' + date_split[1]
        db_record_game = Database::GameOrm.first(date: temp_date)
        db_record_schedule = db_record_game.schedule
        rebuild_entity(db_record_schedule)
      end

      # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end

        def create_schedule
          # 2018-11-13 -> 2018_11_13
          # Correspond to db string constraint
          temp_hash = @entity.to_attr_hash
          temp_date = temp_hash[:date]
          temp_hash[:date] = temp_date.split('-').join('o')

          Database::ScheduleOrm.unrestrict_primary_key
          Database::ScheduleOrm.create(temp_hash)
        end

        def call
          # should create schedule first and then game
          db_schhedule = create_schedule
          @entity.live_games.each do |live_game|
            g = LiveGames.db_find_or_create(live_game)
            #puts g.game_date
          end
          db_schhedule
        end
      end
    end
  end
end
