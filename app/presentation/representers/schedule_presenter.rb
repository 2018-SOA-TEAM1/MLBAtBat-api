# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'livegame_representer'

# Represents essential Schedule information for API output
module MLBAtBat
  module Representer
    # Represent a Schedule entity as Json
    class Schedule < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :date
      property :total_games
      collection :live_games, extend: Representer::LiveGame, class: OpenStruct

      # property :find_team_name

      # Place link in LiveGame presenter?

      # link :self do
      #   "#{Api.config.API_HOST}/projects/#{project_name}/#{owner_name}"
      # end
    end
  end
end
