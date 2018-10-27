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

      def get_schedule(sport_id)
        data = @gateway.schedule(sport_id)
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
            game_date: game_date,
            game_pk: game_pk,
            live_game: live_game
          )
        end

        def game_date
          @data['dates'][0]['date']
        end

        def game_pk
          @data['dates'][0]['games'][0]['gamePk']
        end

        def live_game
          @live_game_mapper.live_game_info(game_pk)
        end
      end
    end
  end
end
