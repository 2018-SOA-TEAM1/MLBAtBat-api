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
        raise err_msg if find(entity)

        db_schedule = PersistProject.new(entity).call
        rebuild_entity(db_schedule)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Schedule.new(
          db_record.to_hash.merge(
            live_game: LiveGames.rebuild_entity(db_record.game),
            id: db_record.game.id,
            pk: db_record.game_pk
          )
        )
      end

      def self.find(entity)
        find_pk(entity.pk)
      end

      def self.find_pk(game_pk)
        db_record = Database::ScheduleOrm.first(game_pk: game_pk)
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
          # change pk -> game_pk
          temp_hash = @entity.to_attr_hash
          game_pk = temp_hash.delete(:pk)
          temp_hash[:game_pk] = game_pk
          Database::ScheduleOrm.unrestrict_primary_key
          Database::ScheduleOrm.create(temp_hash)
        end

        def call
          # should create schedule first and then game
          db_schhedule = create_schedule
          LiveGames.db_find_or_create(@entity.live_game)
          db_schhedule
        end
      end
    end
  end
end
