# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative './player.rb'

module MLBAtBat
  module Entity
    # Store information about innings
    class Players < Dry::Struct
      include Dry::Types.module

      attribute :players,  Strict::Array.of(Player)    
    
    end
  end
end
