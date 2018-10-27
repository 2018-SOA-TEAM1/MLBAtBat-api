# frozen_string_literal: false

module MLBAtBat
  # Provides access to contributor data
  module MLB
    # Data Mapper: Github contributor -> Member entity
    class LiveGameMapper
      def initialize(gateway_class = MLB::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def live_game_info(game_pk)
        build_entity(game_pk)
      end

      def build_entity(game_pk)
        data = @gateway.live_game(game_pk)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::LiveGame.new(
            current_hitter_name: current_hitter_name,
            detailed_state: detailed_state
          )
        end

        def current_hitter_name
          @data['liveData']['plays']['currentPlay'] \
          ['matchup']['batter']['fullName']
        end

        def detailed_state
          @data['gameData']['status']['detailedState']
        end
      end
    end
  end
end
