# frozen_string_literal: true

require 'dry/transaction'
require 'dry/monads'

module MLBAtBat
  module Service
    # Retrieves the searched Livegame entity
    class FindGame
      include Dry::Monads::Result::Mixin

      DB_ERR_MSG = 'Having trouble accessing the database'

      def call(date, team_name)
        game_info = Repository::For.klass(Entity::LiveGame)
          .find(date, team_name)
        if game_info.nil?
          return Failure(Value::Result.new(status: :not_found, message: DB_ERR_MSG))
        end

        Success(Value::Result.new(status: :ok, message: game_info))
      end
    end
  end
end
