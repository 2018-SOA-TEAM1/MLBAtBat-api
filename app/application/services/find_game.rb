# frozen_string_literal: true

require 'dry/transaction'
require 'dry/monads'

module MLBAtBat
  module Service
    # Retrieves array of all listed project entities
    class FindGame
      include Dry::Monads::Result::Mixin

      def call(date, team_name)
        game_info = Repository::For.klass(Entity::LiveGame)
          .find(date, team_name)
        Success(game_info)
      rescue StandardError
        Failure('Can not get game from db using date and team_name.')
      end
    end
  end
end
