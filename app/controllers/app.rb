# frozen_string_literal: true

require 'roda'
require 'slim'

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
        view 'home'
      end

      routing.on 'game_info' do
        routing.is do
          # GET /game_info/
          routing.post do
            game_date = routing.params['game_date']
            # routing.halt 400 unless game_pk.to_i.positive?
            game_date = game_date.split('/').join('_')
            routing.redirect "game_info/#{game_date}"
          end
        end

        routing.on String do |game_date|
          # GET /game_info/game_date
          # puts game_date
          routing.get do
            game_date = game_date.split('_').join('/')
            game_info = MLB::ScheduleMapper.new.get_schedule(1, game_date)

            # Add schedule to database
            # game_info is got from schedule directly
            Repository::For.entity(game_info).create(game_info)
            puts("create schedule")

            view 'game_info', locals: { game_info: game_info }
          end
        end
      end
    end
  end
end
