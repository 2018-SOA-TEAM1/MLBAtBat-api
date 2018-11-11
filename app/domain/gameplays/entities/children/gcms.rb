# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative './gcm.rb'

module MLBAtBat
  module Entity
    # Store information about innings
    class GameChangingMoments < Dry::Struct
      include Dry::Types.module

      attribute :gcms,  GameChangingMoment    
    
    end
  end
end
