# frozen_string_literal: true

module MLBAtBat
  module Mapper
    # Mapper for gcm
    class GameChangingMoment
      def initialize() end

      def play_score_condition(play, last_play)
        return 'normal' if last_play.nil?

        score_gap_last, score_gap_now = gap(play, last_play)
        return 'tie' if tie?(score_gap_last, score_gap_now)
        return 'reverse' if reverse?(score_gap_last, score_gap_now)

        'normal'
      end

      def gap(play, last_play)
        [
          last_play.home_score - last_play.away_score,
          play.home_score - play.away_score
        ]
      end

      def tie?(score_gap_last, score_gap_now)
        return true if !score_gap_last.zero? && score_gap_now.zero?

        false
      end

      def reverse?(score_gap_last, score_gap_now)
        return true if (score_gap_last.positive? || score_gap_last.zero?) \
        && score_gap_now.negative?

        return true if (score_gap_last.negative? || score_gap_last.zero?) \
        && score_gap_now.positive?

        false
      end

      def get_gcms(innings)
        @innings = innings
        gcms = []
        last_play = nil
        (0..innings.length - 1).each do |inning_index|
          plays = innings[inning_index].plays
          plays.each do |play|
            score_condition = play_score_condition(play, last_play)
            if play.home_run_boolean == true
              # homerun in this play
              gcms.push(build_entity(play))
            elsif score_condition == 'tie'
              # tie
              gcms.push(build_entity(play, 'Tie Game'))
            elsif score_condition == 'reverse'
              # reverse
              gcms.push(build_entity(play, 'Reverse Game'))
            end
            last_play = play
          end
        end
        gcms
      end

      def build_entity(play, event = 'play_event')
        DataMapper.new(play, event).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(play, event)
          @play = play
          @event = event
        end

        def build_entity
          Entity::GameChangingMoment.new(
            atBatIndex: at_bat_index,
            inning_index: inning_index,
            description: description,
            event: event
          )
        end

        def at_bat_index
          @play.atBatIndex
        end

        def inning_index
          @play.inning_index
        end

        def description
          @play.description
        end

        def event
          if @event == 'play_event'
            @play.event
          else
            @event
          end
        end
      end
    end
  end
end
