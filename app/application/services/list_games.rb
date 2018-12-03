# frozen_string_literal: true

require 'dry/transaction'
require 'dry/monads'

module MLBAtBat
  module Service
    # Retrieves array of all listed project entities
    class ListGames
      include Dry::Monads::Result::Mixin

      DB_ERR_MSG = 'Could not access database'

      def call
        Repository::For.klass(Entity::LiveGame).all
          .yield_self { |games| Value::GamesList.new(games) }
          .yield_self do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end
      rescue StandardError
        Failure(Value::Result.new(
                  status: :internal_error,
                  message: DB_ERR_MSG
                ))
      end
    end
  end
end
