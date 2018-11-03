# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for LiveGame Entities
    class LiveGames
      def self.rebuild_entity(db_record)
        return nil unless db_record
        # puts("Now in repository games")
        # puts(db_record)
        # puts(db_record.game_pk)
        # puts(db_record.date)
        # puts(db_record.current_hitter_name)
        Entity::LiveGame.new(
          game_pk:             db_record.game_pk,
          date:                db_record.date,
          current_hitter_name: db_record.current_hitter_name
        )
      end

      def self.db_find_or_create(entity)
        Database::GameOrm.find_or_create(entity.to_hash)
      end
    end
  end
end