# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for LiveGame Entities
    class LiveGames
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::LiveGame.new(
          id:                  db_record.id,
          game_pk:             db_record.game_pk,
          date:                db_record.date,
          current_hitter_name: db_record.current_hitter_name
        )
      end

    end
  end
end