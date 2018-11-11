# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../children/innings.rb'
require_relative '../children/players.rb'
require_relative '../children/gcms.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class WholeGame < Dry::Struct
      include Dry::Types.module

      attribute :id,                       Integer.optional
      attribute :innings,                  Innings
      attribute :players,                  Players
      attribute :gcms,                     GameChangingMoments

    end
  end
end
