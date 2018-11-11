# frozen_string_literal: true

require_relative 'plays_mapper.rb'

module MLBAtBat
    module Mapper
      class Inning
        def initialize()
          
        end
        def get_innings(allPlays)
          # 2018.11.11
          # how to map allPLays into innings?
          # return : array of inning (from 1 to ?)

          # allPlays.map do |single_play|
          #   build_entity(single_play)
          # end
          puts "HI"
          puts
        end

        def build_entity(single_play)
          DataMapper.new(single_play).build_entity
        end

        # Extracts entity specific elements from data structure
        class DataMapper
          
        end
      end
    end
  end