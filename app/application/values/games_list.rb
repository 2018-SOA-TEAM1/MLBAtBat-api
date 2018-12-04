# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Value
    # List of projects
    GamesList = Struct.new(:livegames)
  end
end
