# frozen_string_literal: true

require 'http'
require_relative 'schedule.rb'
require_relative 'live_game.rb'

module MLBAtBat
  # Library for MLB API
  class MLBAPI
    def initialize(cache = {})
      @cache = cache
    end

    def schedule
      schedule = Request.new(@cache).data('v1/schedule?sportId=1').parse
      Schedule.new(schedule, self)
    end

    def live_game(game_pk)
      live_data = Request.new(@cache).data("v1.1/game/#{game_pk}/feed/live").parse
      LiveGame.new(live_data)
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
