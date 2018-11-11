# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module MLBAtBat
  module Entity
    # Store information about channnel
    class WholeGame < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :liveData,                 Strict::Hash


    end
  end
end
