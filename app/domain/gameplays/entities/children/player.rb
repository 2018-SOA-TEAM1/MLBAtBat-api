# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about innings
    class Player < Dry::Struct
      include Dry::Types.module

      attribute :name, Strict::String
    end
  end
end
