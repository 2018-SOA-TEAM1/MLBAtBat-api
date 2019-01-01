# frozen_string_literal: true

require 'dry/transaction'

module MLBAtBat
  module Service
    # Transaction to store project from MLB API to database
    class SearchGame
      include Dry::Transaction

      step :find_game_pk
      step :find_whole_game
      step :find_schedule
      step :store_game

      private

      NO_GAME_PK_MSG = 'Can not get game_pk from ScheduleMapper mapper.'
      WHOLEGAME_MAPPER_ERR_MSG = 'Can not get wholegame from WholeGame mapper.'
      SCHEDULE_MAPPER_ERR_MSG = 'Can not get schedule from ScheduleMapper'
      DB_ERR_MSG = 'Having trouble accessing the database'

      # Expects input[:date] and input[:team_name]
      def find_game_pk(input)
        input[:game_pk] = MLB::ScheduleMapper.new.get_gamepk(
          input[:date],
          input[:team_name]
        )
        Success(input)
      rescue StandardError
        Failure(Value::Result.new(status: :bad_request, message: NO_GAME_PK_MSG))
      end

      def find_whole_game(input)
        input[:whole_game] = Mapper::WholeGame.new.build_entity(input[:game_pk])
        Success(input)
      rescue StandardError
        Failure(
          Value::Result.new(
            status: :internal_error,
            message: WHOLEGAME_MAPPER_ERR_MSG
          )
        )
      end

      # through gateway
      def find_schedule(input)
        input[:game_info] = MLB::ScheduleMapper.new.get_schedule(1, input[:date], input[:game_pk])
        # notify worker (for test now)
        notify_workers(input)
        Success(input)
      rescue StandardError
        Failure(
          Value::Result.new(
            status: :internal_error,
            message: SCHEDULE_MAPPER_ERR_MSG
          )
        )
      end

      def store_game(input)
        Repository::For.entity(input[:game_info]).create(input[:game_info],
                                                         input[:team_name])
        Success(Value::Result.new(status: :created, message: input[:whole_game]))
      rescue StandardError
        Failure(
          Value::Result.new(
            status: :internal_error,
            message: DB_ERR_MSG
          )
        )
      end

      def notify_workers(input)
        queues = [Api.config.SCHEDULE_QUEUE_URL]
        queues.each do |queue_url|
          Concurrent::Promise.execute do
            Messaging::Queue.new(queue_url, Api.config)
              .send(schedule_request_json(input))
          end
        end
      end

      def schedule_request_json(input)
        Value::ScheduleRequest.new(input[:date], input[:game_pk])
          .yield_self { |request| Representer::ScheduleRequest.new(request) }
          .yield_self(&:to_json)
      end
    end
  end
end
