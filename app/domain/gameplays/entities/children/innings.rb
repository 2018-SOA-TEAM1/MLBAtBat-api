# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative './inning.rb'

module MLBAtBat
  module Entity
    # Store information about innings
    class Innings < Dry::Struct
      include Dry::Types.module

      attribute :inning,  Strict::Array.of(Inning)
    
    end
  end
end
