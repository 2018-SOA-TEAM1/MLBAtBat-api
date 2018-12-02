# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module MLBAtBat
  module Representer
    # Store information about gcm
    class Play < Roar::Decorator
      include Roar::JSON

      property :atBatIndex
      property :inning_index
      property :description
      property :home_run_boolean
      property :event
    end
  end
end
