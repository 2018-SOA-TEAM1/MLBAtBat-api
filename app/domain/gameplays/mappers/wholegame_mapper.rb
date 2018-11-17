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
          @game_pk = game_pk
          all_plays = data['liveData']['plays']['allPlays']
          live_data = data['liveData']
          @all_plays = all_plays
          @live_data = live_data
          @inning_mapper = Inning.new(all_plays, live_data)
          @player_mapper = Player.new
          @gcm_mapper = GameChangingMoment.new
        end

        def build_entity
          Entity::WholeGame.new(
            game_pk: @game_pk,
            innings: innings,
            home_runs: home_runs,
            home_hits: home_hits,
            home_errors: home_errors,
            away_runs: away_runs,
            away_hits: away_hits,
            away_errors: away_errors,
            # players: players,
            gcms: gcms
          )
        end

        def innings
          @inning_mapper.innings
        end

        # def players
        #   @player_mapper.get_players(@data['gameData'])
        # end

        def gcms
          @gcm_mapper.get_gcms(innings)
        end

        def home_runs
          @live_data['linescore']['teams']['home']['runs']
        end

        def home_hits
          @live_data['linescore']['teams']['home']['hits']
        end

        def home_errors
          @live_data['linescore']['teams']['home']['errors']
        end

        def away_runs
          @live_data['linescore']['teams']['away']['runs']
        end

        def away_hits
          @live_data['linescore']['teams']['away']['hits']
        end

        def away_errors
          @live_data['linescore']['teams']['away']['errors']
        end
      end
    end
  end
end
