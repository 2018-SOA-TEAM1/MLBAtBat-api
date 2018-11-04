# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for Schedule Entities
    class Schedules
      def self.all
        Database::ScheduleOrm.all.map { |db_schedule| rebuild_entity(db_schedule) }
      end

      def self.create(entity)
        raise '(Under development) Sorry: this date Game already exists' if find(entity)
  
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

      def self.find_pk(pk)
        db_record =  Database::ScheduleOrm.first(game_pk: pk)
        rebuild_entity(db_record)
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
          db_schhedule = create_schedule
          live_game = LiveGames.db_find_or_create(@entity.live_game)
          db_schhedule
        end
      end


      
    end
  end
end