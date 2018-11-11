# frozen_string_literal: true
module MLBAtMat
  module Mapper
    # WholeGame Mapper: MLB API -> WholeGame entity
    class WholeGame
      def initialize(gateway_class = MLB::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def get_whole_game(game_pk)
        build_entity(game_pk)
      end

      def build_entity(game_pk)
        data = @gateway.live_game(game_pk)
        DataMapper.new(data, game_pk).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, game_pk)
          @data = data
          @pk = game_pk
        end

        def build_entity
          Entity::WholeGame.new(
            pk: @pk,
            date: date,
            liveData: liveData,
            
          )
        end

        def liveData
          data['liveData']
        end
      
      end
    end
  end
end