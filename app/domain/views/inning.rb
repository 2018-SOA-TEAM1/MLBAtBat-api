# frozen_string_literal: true

module Views
  # View for a single whole_game entity
  class Inning
    attr_reader :index

    def initialize(inning, index)
      @inning = inning
      @index = index
    end

    def index_str
      "inning[#{@index}]"
    end

    def home_runs
      @inning.home_runs
    end

    def away_runs
      @inning.away_runs
    end
  end
end
