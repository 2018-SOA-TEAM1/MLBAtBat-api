# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about innings
    class GameChangingMoment < Dry::Struct
      include Dry::Types.module

      attribute :inning_number,  Strict::Integer    
    
    end
  end
end
