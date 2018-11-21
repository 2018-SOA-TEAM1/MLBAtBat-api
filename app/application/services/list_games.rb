# frozen_string_literal: true

require 'dry/transaction'
require 'dry/monads'

module MLBAtBat
  module Service
    # Retrieves array of all listed project entities
    class ListGames
      include Dry::Monads::Result::Mixin

      def call
        games = Repository::For.klass(Entity::LiveGame).all

        Success(games)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
