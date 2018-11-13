# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about innings
    class Inning < Dry::Struct
      include Dry::Types.module

      attribute :plays,      Plays
    
    end
  end
end
