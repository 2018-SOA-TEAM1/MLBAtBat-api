# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about innings
    class Play < Dry::Struct
      include Dry::Types.module

      attribute :atBatIndex,  Strict::Integer    
    
    end
  end
end
