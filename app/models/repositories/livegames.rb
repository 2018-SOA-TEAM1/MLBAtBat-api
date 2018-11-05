# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for LiveGame Entities
    class LiveGames
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::LiveGame.new(
          pk:                  db_record.g_pk,
          date:                db_record.date,
          current_hitter_name: db_record.current_hitter_name,
          detailed_state:      db_record.detailed_state,
          home_team_runs:      db_record.home_team_runs,
          home_team_hits:      db_record.home_team_hits,
          home_team_errors:    db_record.home_team_errors,
          away_team_runs:      db_record.away_team_runs,
          away_team_hits:      db_record.away_team_hits,
          away_team_errors:    db_record.away_team_errors
        )
      end

      def self.db_find_or_create(entity)
        # to make pk -> g_pk
        temp_hash = entity.to_hash
        temp_pk = temp_hash.delete(:pk)
        temp_hash[:g_pk] = temp_pk

        Database::GameOrm.find_or_create(temp_hash)
      end
    end
  end
end
