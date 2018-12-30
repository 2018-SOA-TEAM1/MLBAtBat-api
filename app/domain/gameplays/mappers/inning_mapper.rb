# frozen_string_literal: true

require_relative './play_mapper.rb'

module MLBAtBat
  module Mapper
    # Mapper of inning / innings
    class Inning
      def initialize(all_plays, live_data)
        @all_plays = all_plays
        @live_data = live_data
      end

      # inning index 1 -> inning[0]
      def get_inning_of_play(single_play)
        single_play['about']['inning'] - 1
      end

      def num_of_inning
        @all_plays[@all_plays.length - 1]['about']['inning']
      end

      def innings
        # get # of inning
        plays = Array.new(num_of_inning) { [] }
        # map each play into plays depending on inning
        @all_plays.map do |single_play|
          plays[get_inning_of_play(single_play)].push(single_play)
        end
        innings = []
        (0..num_of_inning - 1).each do |i|
          innings.push(build_entity(plays[i], i))
        end
        innings
      end

      def build_entity(plays, inning_index)
        DataMapper.new(plays, inning_index, @live_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(plays, inning_index, live_data)
          @play_mapper = Play.new
          @plays = plays
          @inning_index = inning_index
          @live_data = live_data
        end

        def build_entity
          # in avoid of early end in top half 9 of inning
          h_r = home_runs
          h_r ||= 0
          Entity::Inning.new(
            plays: plays,
            home_runs: h_r,
            away_runs: away_runs
          )
        end

        def plays
          @play_mapper.get_plays(@plays)
        end

        def home_runs
          # beacuse live_data inning start from 0
          # (represents inning 1)
          @live_data['linescore']['innings'][@inning_index] \
            ['home']['runs']
        end

        def away_runs
          @live_data['linescore']['innings'][@inning_index] \
            ['away']['runs']
        end
      end
    end
  end
end
