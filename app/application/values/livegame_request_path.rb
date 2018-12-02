# frozen_string_literal: true

module MLBAtBat
  module RouteHelpers
    # Application value for the path of a requested project
    class LiveGameRequestPath
      def initialize(date, team_name, request)
        @date = date
        @team_name = team_name
        # Actually I don't know what is request...
        @request = request
        @path = request.remaining_path
      end

      attr_reader :date, :team_name
    end
  end
end
