# frozen_string_literal: true

require_relative './plays_mapper.rb'

module MLBAtBat
    module Mapper
      class Inning
        def initialize()
          
        end
        def get_innings(allPlays)
          # 2018.11.11
          # how to map allPLays into innings?
          # return : array of inning (from 1 to ?)
          
          puts "This is get_innings."
          # get # of inning
          num_of_plays = allPlays.length - 1
          num_of_inning = allPlays[num_of_plays]['about']['inning']
          # start from 1 for convenient
          innings = Array.new(num_of_inning + 1) { Array.new() } 
          
          allPlays.map do |single_play|
            play = build_entity(single_play)
            innings[play.inning + 1].push(play)
          end
          puts "get_innings end."
          return innings
          
        end

        def build_entity(single_play)
          DataMapper.new(single_play).build_entity
        end

        # Extracts entity specific elements from data structure
        class DataMapper
          def initialize(single_play)
            @single_play = single_play
          end
          
          def build_entity
            Entity::Inning.new(
              plays: plays,
            )
          end

        end
      end
    end
  end