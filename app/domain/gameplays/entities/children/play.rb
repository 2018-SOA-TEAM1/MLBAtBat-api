# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about innings
    class Play < Dry::Struct
      include Dry::Types.module

      attribute :atBatIndex,       Strict::Integer    
      attribute :inning_index,     Strict::Integer
      attribute :description,      Strict::String 
      attribute :home_run_boolean, Strict::Bool
      attribute :event,            Strict::String
    end
  end
end
