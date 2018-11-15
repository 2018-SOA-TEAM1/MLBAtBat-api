# frozen_string_literal: true

module MLBAtBat
  module Mapper
    # Mapper of play / plays
    class Play
      def initialize()

      end

      def get_plays(plays)
        plays.map {|play| rebuild_entity(play)}
      end

      def rebuild_entity(play)
        DataMapper.new().build_entity(play)
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize()

        end

        def build_entity(play)
          Entity::Play.new(
            atBatIndex: atBatIndex(play),
          )
        end

        def atBatIndex(play)
          play['atBatIndex']
        end
      end
    end
  end
end