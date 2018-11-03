# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for Schedule Entities
    class Schedules
      def self.all
        Database::ScheduleOrm.all.map { |db_schedule| rebuild_entity(db_schedule) }
      end

      def self.create(entity)
        # igonre funcion below at this moment
        # raise 'QAQ this date Game already exists' if find(entity)
  
        db_schedule = PersistProject.new(entity).call
        #live_game = entity.live_game
        rebuild_entity(db_schedule)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record
        
        # db_record doesn't contain live_game
        puts ("Try to rebuild_entity")
        puts db_record.to_hash
        puts db_record.live_game
        Entity::Schedule.new(
          db_record.to_hash.merge(
            live_game: LiveGames.rebuild_entity(db_record.live_game)
          )
        ) 
      end

      # def self.find(entity)
      #   find_pk(entity.pk)
      # end

      # def self.find_pk(pk)
      #   db_record =  Database::ScheduleOrm.first(pk: pk)
      #   rebuild_entity(db_record)
      # end

        # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end
  
        def create_schedule
          # puts("1")
          # puts(@entity)
          # puts("2")
          # puts(@entity.to_attr_hash)
          Database::ScheduleOrm.create(@entity.to_attr_hash)
        end

        def call
          db_schhedule = create_schedule
   
          # puts "@entity.live_game: "
          # puts @entity.live_game
          # @entity is Entity:Schedule
          # live_game is GameOrm
          live_game = LiveGames.db_find_or_create(@entity.live_game)
          # create_schedule.tap do |db_schedule|
          #   db_schedule.update(game: live_game)
          # end

          # update schedule_orm.rb
          # db_schhedule.update(game: live_game)
        end
      end


      
    end
  end
end