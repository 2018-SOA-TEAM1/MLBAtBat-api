# frozen_string_literal: true

require_relative './play_mapper.rb'

module MLBAtBat
    module Mapper
      # Mapper of inning / innings
      class Inning
        def initialize(allPlays, live_data)
          @allPlays = allPlays
          @live_data = live_data
        end

        def get_inning_of_play (single_play)
          single_play['about']['inning']
        end

        def get_innings()          
          # get # of inning
          num_of_plays = @allPlays.length - 1
          num_of_inning = @allPlays[num_of_plays]['about']['inning']
          plays = Array.new(num_of_inning + 1) { Array.new() }
          # map each play into plays depending on inning
          @allPlays.map do |single_play|
            plays[get_inning_of_play(single_play)].push(single_play)
          end

          innings = Array.new()
          # start from 1 for convenien
          # add 0th null inning (not used)
          innings.push("Null_inning")
          for i in 1..num_of_inning
            # in livedata: inning[0] -> inning 1
            innings.push(build_entity(plays[i], i))
          end
          return innings
        end

        def build_entity(plays, inning_index)
          DataMapper.new(plays, inning_index, @live_data).build_entity()
        end

        # Extracts entity specific elements from data structure
        class DataMapper
          def initialize(plays, inning_index, live_data)
            @play_mapper = Play.new()
            @plays = plays
            @inning_index = inning_index
            @live_data = live_data
          end
          
          def build_entity()
            Entity::Inning.new(
              plays: get_plays,
              home_runs: home_runs,
              away_runs: away_runs,
            )
          end

          def get_plays()
            @play_mapper.get_plays(@plays)
          end

          def home_runs()
            # beacuse live_data inning start from 0 
            # (represents inning 1)
            @live_data['linescore']['innings'][@inning_index - 1] \
              ['home']['runs']
          end

          def away_runs()
            @live_data['linescore']['innings'][@inning_index - 1] \
              ['away']['runs']
          end
        end
      end
    end
  end