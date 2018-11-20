# frozen_string_literal: true

module Views
  # View for a single gcm entity
  class GameChangingMoment
    def initialize(gcm)
      @gcm = gcm
    end

    def inning_index
      @gcm.inning_index
    end

    def event
      @gcm.event
    end

    def description
      @gcm.description
    end
  end
end
