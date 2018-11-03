# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for Schedule Entities
    class Schedules
      def self.create(entity)
        # igonre funcion below at this moment
        # raise 'LiveGame already exists' if find(entity)
  
        db_schedule = PersistProject.new(entity).call
        rebuild_entity(db_schedule)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record
        
        # # add entity has but not in database 
        # Entity::Schedule.new(
        #   db_record.to_hash.merge(
        #     live_game: LiveGames.rebuild_entity(db_record.live_game)
        #   )
        # ) 
        db_record
      end
      
        # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end
  
        def create_schedule
          puts("1")
          puts(@entity)
          puts("2")
          puts(@entity.to_attr_hash)
          Database::ScheduleOrm.create(@entity.to_attr_hash)
        end

        def call
          create_schedule
        end
      end


      
    end
  end
end