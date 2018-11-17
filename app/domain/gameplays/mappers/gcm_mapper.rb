# frozen_string_literal: true

module MLBAtBat
  module Mapper
    class GameChangingMoment
      def initialize()
        
      end

      def get_gcms(innings)
        @innings = innings
        gcms = Array.new()
        # remove inning 0
        for inning_index in 1..innings.length - 1
          plays = innings[inning_index].plays
          plays.each do |play|
            # condition for choosing gcm
            gcms.push(build_entity(play)) if play.home_run_boolean == true
          end
        end
        return gcms
      end

      def build_entity(play)
        DataMapper.new(play).build_entity()
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(play)
          @play = play
        end

        def build_entity()
          Entity::GameChangingMoment.new(
            atBatIndex: atBatIndex,
            inning_index: inning_index,
            description: description,
            event: event
          )
        end

        def atBatIndex
          @play.atBatIndex
        end

        def inning_index
          @play.inning_index
        end

        def description
          @play.description
        end

        def event
          @play.event
        end
      end
    end
  end
end