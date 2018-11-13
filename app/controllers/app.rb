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
        view 'home', locals: { games: games }
      end

      routing.on 'game_info' do
        routing.is do
          # GET /game_info/
          routing.post do
            date = routing.params['game_date']
            team_name = routing.params['team_name']
            # routing.halt 400 unless pk.to_i.positive?
            game_info = MLB::ScheduleMapper.new.get_schedule(1, date)
            # Add schedule to database
            Repository::For.entity(game_info).create(game_info, team_name)

            date = date.split('/').join('_')
            routing.redirect "game_info/#{date}"
          end
        end

        routing.on String do |date|
          # GET /game_info/date
          routing.get do
            date = date.split('_').join('/')
            # Get schedule (game_info) from database instead of Github
            game_info = Repository::For.klass(Entity::Schedule)
              .find_date(date)

            # domain branch
            # game_pk = game_info.game_pk
            # whole_game = Mapper::WholeGame.new.get_game(game_pk)
            

            view 'game_info', locals: { game_info: game_info }
          end
        end
      end
    end
  end
end
