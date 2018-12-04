# frozen_string_literal: true

require 'roda'

module MLBAtBat
  # Web App
  class Api < Roda
    # plugins
    plugin :halt
    plugin :all_verbs
    use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "MLBAtBat API v1 at /api/v1/ in #{Api.environment} mode"

        result_response = Representer::HttpResponse.new(
          Value::Result.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'games' do
          routing.on String, String do |game_date, team_name|
            # POST /games/{game_date}/{team_name}
            game_date = game_date.split('-').join('/')
            team_name = team_name.split('-').join(' ')
            routing.post do
              input = { date: game_date, team_name: team_name }
              result = Service::SearchGame.new.call(input)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::WholeGame.new(
                result.value!.message
              ).to_json
            end

            # GET /games/{game_date}/{team_name}
            routing.get do
              result = Service::FindGame.new.call(game_date, team_name)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::LiveGame.new(
                result.value!.message
              ).to_json
            end
          end

          routing.on 'first' do
            # GET /games/first
            routing.get do
              result = Service::ListDbGame.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::WholeGame.new(result.value!.message).to_json
            end
          end

          routing.is do
            # GET /games
            routing.get do
              result = Service::ListGames.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::LivegamesList.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
