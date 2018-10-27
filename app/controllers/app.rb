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
            game_pk = routing.params['game_pk']
            routing.halt 400 unless game_pk.to_i.positive?

            routing.redirect "game_info/#{game_pk}"
          end
        end

        routing.on String do |game_pk|
          # GET /game_info/game_pk
          routing.get do
            live_game_info = MLB::LiveGameMapper.new.live_game_info(game_pk)

            view 'game_info', locals: { game_info: live_game_info }
          end
        end
      end
    end
  end
end
