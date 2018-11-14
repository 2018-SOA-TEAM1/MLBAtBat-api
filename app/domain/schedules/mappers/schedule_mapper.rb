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

      def get_schedule(sport_id, date)
        data = @gateway.schedule(sport_id, date)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @gateway_class).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, gateway_class)
          @data = data
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

        def pks
          out = []
          @data['dates'][0]['games'].each do |game|
            out << game['gamePk']
          end
          out
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
          @live_game_mapper.load_several(pks)
        end
      end
    end
  end
end