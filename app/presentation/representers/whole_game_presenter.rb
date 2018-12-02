# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'inning_representer'
require_relative 'game_changing_moment_representer'

module MLBAtBat
  module Representer
    # Represents wholegame (contains all game information)
    class WholeGame < Roar::Decorator
      include Roar::JSON

      property :game_pk
      property :innings
      property :home_runs
      property :home_hits
      property :home_errors
      property :away_runs
      property :away_hits
      property :away_errors
      property :home_team_name
      property :away_team_name
      collection :gcms, extend: Representer::GameChangingMoment, class: OpenStruct
    end
  end
end
