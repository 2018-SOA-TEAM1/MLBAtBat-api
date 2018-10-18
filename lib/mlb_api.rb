# frozen_string_literal: true

require 'http'
require_relative 'schedule.rb'
require_relative 'live_game.rb'

module MLBAtBat
  # Library for Youtube Data API
  class MLBAPI
    module Errors
      class NotFound < StandardError; end
    end

    HTTP_ERROR = {
      404 => Errors::NotFound
    }.freeze

    def initialize(cache = {})
      @cache = cache
    end

    def schedule
      mlb_schedule_url = mlb_api_path('v1/schedule?sportId=1')
      schedule = call_mlb_url(mlb_schedule_url).parse
      Schedule.new(schedule, self)
    end

    def live_game(game_pk)
      live_api_path = "v1.1/game/#{game_pk}/feed/live"
      mlb_live_url = mlb_api_path(live_api_path)
      live_data = call_mlb_url(mlb_live_url).parse
      LiveGame.new(live_data)
    end

    private

    def mlb_api_path(path)
      'https://statsapi.mlb.com/api/' + path
    end

    def call_mlb_url(url)
      result = @cache.fetch(url) do
        HTTP.get(url)
      end

      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.key?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
