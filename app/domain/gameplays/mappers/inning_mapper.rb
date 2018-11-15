# frozen_string_literal: true

require_relative './play_mapper.rb'

module MLBAtBat
    module Mapper
      # Mapper of inning / innings
      class Inning
        def initialize()
          
        end

        def self.get_inning_of_play (single_play)
          single_play['about']['inning']
        end

        def get_innings(allPlays)          
          puts "This is get_innings."
          # get # of inning
          num_of_plays = allPlays.length - 1
          num_of_inning = allPlays[num_of_plays]['about']['inning']
          
          plays = Array.new(num_of_inning + 1) { Array.new() }
          # map each play into plays depending on inning
          allPlays.map do |single_play|
            plays[get_inning_of_play(single_play)].push(single_play)
          end

          innings = Array.new()
          # start from 1 for convenien
          # add 0th null inning (not used)
          innings.push("Null_inning")
          for i in 1..num_of_inning
            innings.push(build_entity(plays[i]))
          end
          
          puts "get_innings end."
          return innings
        end

        def self.build_entity(plays)
          DataMapper.new(plays).build_entity
        end

        # Extracts entity specific elements from data structure
        class DataMapper
          def initialize()
            @play_mapper = Play.new()
          end
          
          def build_entity(plays)
            Entity::Inning.new(
              plays: get_plays(plays),
            )
          end

          def get_plays(plays)
            @play_mapper.get_plays(plays)
          end
        end
      end
    end
  end