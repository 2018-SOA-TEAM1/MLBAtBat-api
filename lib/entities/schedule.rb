# frozen_string_literal: true

require_relative 'live_game.rb'

module MLBAtBat
  module Entity
    # Store information about channnel
    class Schedule < Dry::Struct
      include Dry::Types.module

      attribute :game_date,                Strict::String
      attribute :game_pk,                  Strict::Integer
      attribute :live_game,                LiveGame

      # def initialize(schedule, data_source)
      #   @schedule = schedule
      #   @data_source = data_source
      # end
      #
      # def game_date
      #   @schedule['dates'][0]['date']
      # end
      #
      # def game_pk
      #   @schedule['dates'][0]['games'][0]['gamePk']
      # end
      #
      # def game_detailed_state(gpk = game_pk)
      #   @game_detailed_state ||= @data_source.live_game(gpk).detailed_state
      # end
      #
      # def current_hitter_name(gpk = game_pk)
      #   @current_hitter_name ||= @data_source.live_game(gpk) \
      #                                        .current_hitter_name
      # end
    end
  end
end
