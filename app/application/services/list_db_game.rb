# frozen_string_literal: true

require 'dry/transaction'
require 'dry/monads'

module MLBAtBat
  module Service
    # Retrieves first game in db (it should have at least 1 record in db)
    class ListDbGame
      include Dry::Monads::Result::Mixin

      DB_ERR_MSG = 'Having trouble accessing the database'

      def whole_game
        game_pk = gamepk
        whole_game = Mapper::WholeGame.new.get_whole_game(game_pk)

        Success(Value::Result.new(status: :ok, message: whole_game))
      rescue StandardError
        Failure(
          Value::Result.new(
            status: :internal_error,
            message: DB_ERR_MSG
          )
        )
      end

      def gamepk
        first_game = first_game_in_database
        date = first_game.date.to_s
        date = (date[4...6] + '/' + date[6...8] + '/' + date[0...4])
        team_name = first_game.home_team_name
        MLB::ScheduleMapper.new.get_gamepk(date, team_name)
      end

      def first_game_in_database
        Repository::For.klass(Entity::LiveGame).first
      end
    end
  end
end
