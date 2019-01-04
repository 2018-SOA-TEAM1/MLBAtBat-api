# frozen_string_literal: true

module MLBAtBat
  module Mapper
    # Mapper of play / plays
    class Play
      def get_plays(plays)
        plays.map { |play| rebuild_entity(play) }
      end

      def rebuild_entity(play)
        DataMapper.new(play).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(play)
          @play = play
        end

        def build_entity
          Entity::Play.new(
            atBatIndex: at_bat_index,
            inning_index: inning_index,
            description: description,
            home_run_boolean: home_run_boolean,
            event: event,
            home_score: home_score,
            away_score: away_score
          )
        end

        def at_bat_index
          @play['atBatIndex']
        end

        def inning_index
          @play['about']['inning']
        end

        def description
          @play['result']['description']
        end

        def home_run_boolean
          event = @play['result']['event']
          if event == 'Home Run'
            return true
          else
            return false
          end
        end

        def event
          @play['result']['event']
        end

        def home_score
          @play['result']['homeScore']
        end

        def away_score
          @play['result']['awayScore']
        end
      end
    end
  end
end
