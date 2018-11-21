# frozen_string_literal: true

require 'dry/transaction'

module MLBAtBat
  module Service
    # Transaction to store project from Github API to database
    class FindGame
      include Dry::Transaction

      step :validate_input
      step :find_game_pk
      step :find_whole_game
      step :find_schedule
      step :store_game

      private

      def validate_input(input)
        if input[:date].success?
          date = input[:date][:game_date]
          Success(date: date, team_name: input[:team_name])
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def find_game_pk(input)
        game_pk = MLB::ScheduleMapper.new.get_gamepk(input[:date],
                                                     input[:team_name])
        Success(game_pk: game_pk, date: input[:date],
                team_name: input[:team_name])
      rescue StandardError
        Failure('Can not get game_pk from ScheduleMapper mapper
          (through api).')
      end

      def find_whole_game(input)
        whole_game = Mapper::WholeGame.new.build_entity(input[:game_pk])
        Success(whole_game: whole_game, date: input[:date],
                team_name: input[:team_name])
      rescue StandardError
        Failure('Can not get wholegame from WholeGame mapper.')
      end

      def find_schedule(input)
        game_info = MLB::ScheduleMapper.new.get_schedule(1, input[:date])
        Success(whole_game: input[:whole_game], game_info: game_info,
                team_name: input[:team_name])
      rescue StandardError
        Failure('Can not get schedule from ScheduleMapper')
      end

      def store_game(input)
        Repository::For.entity(input[:game_info]).create(input[:game_info],
                                                         input[:team_name])
        Success(input[:whole_game])
      rescue StandardError
        Failure('Having trouble adding schedule/game into db.')
      end
    end
  end
end
