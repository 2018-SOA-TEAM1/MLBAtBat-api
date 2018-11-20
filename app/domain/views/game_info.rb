# frozen_string_literal: true

module Views
  # View for a single gameinfo entity
  class GameInfo
    def initialize(game_info)
      @game_info = game_info
    end

    def date
      @game_info.date
    end

    def detailed_state
      @game_info.detailed_state
    end

    def current_hitter_name
      @game_info.current_hitter_name
    end

    def home_team_runs
      @game_info.home_team_runs
    end

    def home_team_hits
      @game_info.home_team_hits
    end

    def home_team_errors
      @game_info.home_team_errors
    end

    def away_team_runs
      @game_info.away_team_runs
    end

    def away_team_hits
      @game_info.away_team_hits
    end

    def away_team_errors
      @game_info.away_team_errors
    end
  end
end
