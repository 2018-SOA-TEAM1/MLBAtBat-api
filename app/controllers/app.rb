# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'pry'
require 'date'

module MLBAtBat
  # Web App
  class App < Roda
    # plugins
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'datepicker.js'

    use Rack::MethodOverride

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        games = Repository::For.klass(Entity::LiveGame).all
        if games.any? && $whole_game.nil?
          first_game = Repository::For.klass(Entity::LiveGame).first
          date = first_game.date.to_s
          date = (date[4...6] + '/' + date[6...8] + '/' + date[0...4])
          team_name = first_game.home_team_name
          game_pk = MLB::ScheduleMapper.new.get_gamepk(date, team_name)
          $whole_game = Mapper::WholeGame.new.get_whole_game(game_pk)
        end
        if valid_date?(routing.cookies['date'])
          date = routing.cookies['date']
          team_name = MLB::ScheduleMapper.new.get_team_name(date)
        end
        view 'home', locals: { games: games, whole_game: $whole_game,
                               team_name: team_name }
      end

      routing.on 'game_info' do
        routing.is do
          # GET /game_info/
          routing.post do
            date = routing.params['game_date']
            team_name = routing.params['team_name']
            game_info = MLB::ScheduleMapper.new.get_schedule(1, date)

            # build whole game
            game_pk = MLB::ScheduleMapper.new.get_gamepk(date, team_name)
            $whole_game = Mapper::WholeGame.new.build_entity(game_pk)

            # Add schedule (and game) to database
            Repository::For.entity(game_info).create(game_info, team_name)

            date = date.split('/').join('_')
            team_name = team_name.split(' ').join('_')
            routing.redirect "game_info/#{date}/#{team_name}"
          end
        end

        routing.on String, String do |date, team_name|
          # GET /game_info/date/team_name
          routing.get do
            date = date.split('_').join('/')
            team_name = team_name.split('_').join(' ')
            game_info = Repository::For.klass(Entity::LiveGame)
              .find(date, team_name)
            view 'game_info', locals: { game_info: game_info }
          end
        end
      end
    end

    def valid_date?(str, format = '%m/%d/%Y')
      Date.strptime(str, format)
    rescue StandardError
      false
    end
  end
end
