# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'play_representer'

module MLBAtBat
  module Representer
    # Represents wholegame (contains all game information)
    class Inning < Roar::Decorator
      include Roar::JSON

      property :home_runs
      property :away_runs
      collection :plays, extend: Representer::Play, class: OpenStruct
    end
  end
end
