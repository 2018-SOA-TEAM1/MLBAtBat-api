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
        DataMapper.new(data, game_pk).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, game_pk)
          @data = data
          @pk = game_pk
        end

        def build_entity
          Entity::LiveGame.new(
            id: nil,
            pk: @pk,
            date: date,
            current_hitter_name: current_hitter_name,
            detailed_state: detailed_state,
            home_team_runs: home_team_runs,
            home_team_hits: home_team_hits,
            home_team_errors: home_team_errors,
            away_team_runs: away_team_runs,
            away_team_hits: away_team_hits,
            away_team_errors: away_team_errors
          )
        end

        def date
          @data['gameData']['datetime']['originalDate']
        end

        def current_hitter_name
          @data['liveData']['plays']['currentPlay'] \
          ['matchup']['batter']['fullName']
        end

        def detailed_state
          @data['gameData']['status']['detailedState']
        end

        def home_team_runs
          @data['liveData']['linescore']['teams'] \
               ['home']['runs']
        end

        def home_team_hits
          @data['liveData']['linescore']['teams'] \
               ['home']['hits']
        end

        def home_team_errors
          @data['liveData']['linescore']['teams'] \
               ['home']['errors']
        end

        def away_team_runs
          @data['liveData']['linescore']['teams'] \
               ['away']['runs']
        end

        def away_team_hits
          @data['liveData']['linescore']['teams'] \
               ['away']['hits']
        end

        def away_team_errors
          @data['liveData']['linescore']['teams'] \
               ['away']['errors']
        end
      end
    end
  end
end
