# frozen_string_literal: true

module MLBAtBat
  module Entity
    # Store information about videos from channel's playlist
    class LiveGame < Dry::Struct
      include Dry::Types.module

      attribute :current_hitter_name,  Strict::String
      attribute :detailed_state,       Strict::String
      # def initialize(live_game_data)
      #   @live_game_data = live_game_data
      # end
      #
      # def current_hitter_name
      #   @live_game_data['liveData']['plays']['currentPlay'] \
      #                  ['matchup']['batter']['fullName']
      # end
      #
      # def detailed_state
      #   @live_game_data['gameData']['status']['detailedState']
      # end
    end
  end
end
