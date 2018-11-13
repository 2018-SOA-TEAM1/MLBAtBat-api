# frozen_string_literal: true

module MLBAtBat
  module Repository
    # Repository for LiveGame Entities
    class LiveGames
      def self.all
        Database::GameOrm.all.map do |db_game|
          rebuild_entity(db_game)
        end
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::LiveGame.new(
          id:                  db_record.id,
          date:                db_record.game_date,
          current_hitter_name: db_record.current_hitter_name,
          detailed_state:      db_record.detailed_state,
          home_team_name:      db_record.home_team_name,
          away_team_name:      db_record.away_team_name,
          home_team_runs:      db_record.home_team_runs,
          home_team_hits:      db_record.home_team_hits,
          home_team_errors:    db_record.home_team_errors,
          away_team_runs:      db_record.away_team_runs,
          away_team_hits:      db_record.away_team_hits,
          away_team_errors:    db_record.away_team_errors
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_livegame|
          LiveGames.rebuild_entity(db_livegame)
        end
      end

      def self.db_find_or_create(entity)
        # to make date -> game_date
        temp_hash = entity.to_attr_hash
        temp_date = temp_hash.delete(:date)
        temp_hash[:game_date] = temp_date
        Database::GameOrm.find_or_create(temp_hash)
      end
    end
  end
end
