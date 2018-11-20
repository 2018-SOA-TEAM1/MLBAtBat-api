# frozen_string_literal: true

folders = %w[schedules gameplays views]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end