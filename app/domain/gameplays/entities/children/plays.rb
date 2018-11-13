# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative './play.rb'

module MLBAtBat
  module Entity
    # Store information about innings
    class Plays < Dry::Struct
      include Dry::Types.module

      attribute :play,  Strict::Array.of(Play)    
    
    end
  end
end