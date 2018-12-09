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

      def get_inning_of_play(single_play)
        single_play['about']['inning']
      end

      def innings
        # get # of inning
        num_of_inning = @all_plays[@all_plays.length - 1]['about']['inning']
        plays = Array.new(num_of_inning + 1) { [] }
        # map each play into plays depending on inning
        @all_plays.map do |single_play|
          plays[get_inning_of_play(single_play)].push(single_play)
        end
        innings = ['Null_inning']
        # start from 1 for convenien
        # add 0th null inning (not used)
        (1..num_of_inning).each do |i|
          # in livedata: inning[0] -> inning 1
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
          Entity::Inning.new(
            plays: plays,
            home_runs: home_runs,
            away_runs: away_runs
          )
        end

        def plays
          @play_mapper.get_plays(@plays)
        end

        def home_runs
          # beacuse live_data inning start from 0
          # (represents inning 1)
          @live_data['linescore']['innings'][@inning_index - 1] \
            ['home']['runs']
        end

        def away_runs
          @live_data['linescore']['innings'][@inning_index - 1] \
            ['away']['runs']
        end
      end
    end
  end
end
