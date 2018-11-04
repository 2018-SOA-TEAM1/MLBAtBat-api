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
        schedules = Repository::For.klass(Entity::Schedule).all
        view 'home', locals: { schedules: schedules }
      end

      routing.on 'game_info' do
        routing.is do
          # GET /game_info/
          routing.post do
            date = routing.params['game_date']
            # routing.halt 400 unless pk.to_i.positive?
            date = date.split('/').join('_')
            routing.redirect "game_info/#{date}"
          end
        end

        routing.on String do |date|
          # GET /game_info/date
          # puts date
          routing.get do
            date = date.split('_').join('/')
            # game_info is Entity:Schedule
            game_info = MLB::ScheduleMapper.new.get_schedule(1, date)

            # Add schedule to database
            Repository::For.entity(game_info).create(game_info)
            view 'game_info', locals: { game_info: game_info }
          end
        end
      end
    end
  end
end
