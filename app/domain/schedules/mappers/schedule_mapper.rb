# frozen_string_literal: false

require_relative 'live_game_mapper.rb'

module MLBAtBat
  module MLB
    # Schedule Mapper: MLB API -> Schedule entity
    class ScheduleMapper
      def initialize(gateway_class = MLB::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def get_schedule(sport_id, date, game_pk)
        data = @gateway.schedule(sport_id, date)
        build_entity(data, game_pk)
      end

      def get_team_name(date)
        data = @gateway.schedule(1, date)
        games = data['dates'][0]['games']
        team_name = []
        games.each do |game|
          game_teams = game['teams']
          team_name << game_teams['home']['team']['name']
          team_name << game_teams['away']['team']['name']
        end
        team_name
      end

      def get_gamepk(game_date, team_name)
        data = @gateway.schedule(1, game_date)
        games = data['dates'][0]['games']
        search_pk(games, team_name)
      end

      def search_pk(games, team_name)
        games.each do |game|
          game_teams = game['teams']
          name_array = [game_teams['away']['team']['name'],
                        game_teams['home']['team']['name']]
          return game['gamePk'] if name_array.include? team_name
        end
        nil
      end

      def build_entity(data, game_pk)
        DataMapper.new(data, @gateway_class, game_pk).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, gateway_class, game_pk)
          @data = data
          @game_pk = game_pk.is_a?(Array) ? game_pk : [game_pk]
          @live_game_mapper = LiveGameMapper.new(
            gateway_class
          )
        end

        def build_entity
          MLBAtBat::Entity::Schedule.new(
            id: nil,
            date: date,
            total_games: total_games,
            live_games: live_games
          )
        end

        def date
          # Transform into integer
          # 2018-11-13 -> 20181113
          @data['dates'][0]['date'].split('-').join('').to_i
        end

        def total_games
          @data['dates'][0]['totalGames']
        end

        def live_games
          @live_game_mapper.load_several(@game_pk)
        end
      end
    end
  end
end
