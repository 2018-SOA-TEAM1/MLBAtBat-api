# frozen_string_literal: true

require 'dry/transaction'
require 'dry/monads'

module MLBAtBat
  module Service
    # Retrieves array of all listed project entities
    class FindGame
      include Dry::Monads::Result::Mixin

      DB_ERR_MSG = 'Having trouble accessing the database'

      def call(date, team_name)
        game_info = Repository::For.klass(Entity::LiveGame)
          .find(date, team_name)
        Success(Value::Result.new(status: :ok, message: game_info))
      rescue StandardError
        Failure(Value::Result.new(
                  status: :internal_error,
                  message: DB_ERR_MSG
                ))
      end
    end
  end
end
