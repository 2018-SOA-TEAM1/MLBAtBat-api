# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module MLBAtBat
  module Representer
    # Store information about gcm
    class GameChangingMoment < Roar::Decorator
      include Roar::JSON

      property :atBatIndex
      property :inning_index
      property :description
      property :event
    end
  end
end
