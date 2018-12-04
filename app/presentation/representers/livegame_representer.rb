# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module MLBAtBat
  module Representer
    # Represents essential LiveGame information for API output
    # USAGE:
    #   live_game = Database::GameOrm.find(???)
    #   Representer::LiveGame.new(live_game).to_json
    class LiveGame < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :date
      property :game_pk
      property :current_hitter_name
      property :detailed_state
      property :home_team_name
      property :away_team_name
      property :home_team_runs
      property :home_team_hits
      property :home_team_errors
      property :away_team_runs
      property :away_team_hits
      property :away_team_errors

      # link :self do
      #   "#{Api.config.API_HOST}/projects/#{game_date}/#{game_team_name}"
      # end

      def game_date
        represented.date
      end

      def game_team_name
        # home_team_name or away_team_name ???
        represented.home_team_name
      end
    end
  end
end
