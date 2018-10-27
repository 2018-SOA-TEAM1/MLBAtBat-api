# frozen_string_literal: true

module MLBAtBat
  module Entity
    # Store information about videos from channel's playlist
    class LiveGame < Dry::Struct
      include Dry::Types.module

      attribute :date,                 Strict::String
      attribute :current_hitter_name,  Strict::String
      attribute :detailed_state,       Strict::String
    end
  end
end
