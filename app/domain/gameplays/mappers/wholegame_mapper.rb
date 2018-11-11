# frozen_string_literal: true

require_relative 'inning_mapper.rb'
require_relative 'player_mapper.rb'
require_relative 'gcm_mapper.rb'

module MLBAtBat
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
          @inning_mapper = Inning.new()
          @player_mapper = Player.new()
          @gcm_mapper = GameChangingMoment.new()
        end

        def build_entity
          Entity::WholeGame.new(
            pk: @pk,
            innings: innings,
            # players: players,
            # gcms: gcms
          )
        end

        def innings
          @inning_mapper.get_innings(@data['liveData']['plays']['allPlays'])
        end

        # def players
        #   @player_mapper.get_players(@data['gameData'])
        # end

        # def gcms
        #   @gcm_mapper.get_gcms(@data['liveData']['plays']['allPlays'])
        # end
      
      end
    end
  end
end