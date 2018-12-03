# frozen_string_literal: true

require 'dry/transaction'

module MLBAtBat
  module Service
    # Transaction to store project from Github API to database
    class SearchGame
      include Dry::Transaction

      # step :validate_input
      step :find_game_pk
      step :find_whole_game
      step :find_schedule
      step :store_game

      private

      NO_GAME_PK_MSG = 'Can not get game_pk from ScheduleMapper mapper.'
      WHOLEGAME_MAPPER_ERR_MSG = 'Can not get wholegame from WholeGame mapper.'
      SCHEDULE_MAPPER_ERR_MSG = 'Can not get schedule from ScheduleMapper'
      DB_ERR_MSG = 'Having trouble accessing the database'

      # def validate_input(input)
      #   if input[:date].success?
      #     date = input[:date][:game_date]
      #     Success(date: date, team_name: input[:team_name])
      #   else
      #     Failure(input[:date].errors.values.join('; '))
      #   end
      # end

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

      def find_schedule(input)
        input[:game_info] = MLB::ScheduleMapper.new.get_schedule(1, input[:date])
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
    end
  end
end
