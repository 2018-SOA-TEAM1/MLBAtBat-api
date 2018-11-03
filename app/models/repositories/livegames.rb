# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for LiveGame Entities
    class LiveGames
      def self.rebuild_entity(db_record)
        return nil unless db_record
        # puts("Now in repository games")
        # puts(db_record)
        # puts(db_record.pk)
        # puts(db_record.date)
        # puts(db_record.current_hitter_name)
        Entity::LiveGame.new(
          pk:             db_record.pk,
          date:                db_record.date,
          current_hitter_name: db_record.current_hitter_name
        )
      end

      def self.db_find_or_create(entity)
        # to make pk -> game_pk
        temp_hash = entity.to_hash
        temp_pk = temp_hash.delete(:pk)
        temp_hash[:game_pk] = temp_pk
        
        puts "Create GameOrm"
        puts temp_hash

        Database::GameOrm.find_or_create(temp_hash)
      end
    end
  end
end