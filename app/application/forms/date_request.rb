# frozen_string_literal: true

require 'dry-validation'

module MLBAtBat
  module Forms
    DateRequest = Dry::Validation.Params do
      DATE_REGEX = %r{\A(?:(?:(?:(?:0?[13578])|(1[02]))/31/(19|20)?\d\d)|(?:(?:(?:0?[13-9])|(?:1[0-2]))/(?:29|30)/(?:19|20)?\d\d)|(?:0?2/29/(?:19|20)(?:(?:[02468][048])|(?:[13579][26])))|(?:(?:(?:0?[1-9])|(?:1[0-2]))/(?:(?:0?[1-9])|(?:1\d)|(?:2[0-8]))/(?:19|20)?\d\d))\Z}

      required(:game_date).filled(format?: DATE_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/date_request.yml')
      end
    end
  end
end
