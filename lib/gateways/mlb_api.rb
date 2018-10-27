# frozen_string_literal: true

require 'http'

module MLBAtBat
  module MLB
    # Library for MLB API
    class Api
      def initialize(cache = {})
        @cache = cache
      end

      def schedule(sport_id)
        Request.new(@cache).data("v1/schedule?sportId=#{sport_id}").parse
      end

      def live_game(game_pk)
        Request.new(@cache).data("v1.1/game/#{game_pk}/feed/live").parse
      end

      # send out HTTP request to MLB stats api
      class Request
        MLB_API_PATH = 'https://statsapi.mlb.com/api/'

        def initialize(cache = {})
          @cache = cache
        end

        def data(path)
          get(MLB_API_PATH + path)
        end

        def get(url)
          http_response = @cache.fetch(url) do
            HTTP.get(url)
          end

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from MLB with success/error
      class Response < SimpleDelegator
        # Instance a error class for 404 response
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.key?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
