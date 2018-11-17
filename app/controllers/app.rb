# frozen_string_literal: true

require 'roda'
require 'slim'
require 'pry'

module MLBAtBat
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        games = Repository::For.klass(Entity::LiveGame).all
        # whole_game = MLB::Mapper::WholeGame.new.build_entity(@game_pk)
        view 'home', locals: { games: games }
      end

      routing.on 'game_info' do
        routing.is do
          # GET /game_info/
          routing.post do
            date = routing.params['game_date']
            team_name = routing.params['team_name']
            game_info = MLB::ScheduleMapper.new.get_schedule(1, date)
            @game_pk = MLB::ScheduleMapper.new.get_gamepk(date, team_name)
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
  end
end
