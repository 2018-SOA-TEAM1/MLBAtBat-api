# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'livegame_representer'

module MLBAtBat
  module Representer
    # Represents list of projects for API output
    class LivegamesList < Roar::Decorator
      include Roar::JSON

      collection :livegames, extend: Representer::LiveGame,
                             class: OpenStruct
    end
  end
end
