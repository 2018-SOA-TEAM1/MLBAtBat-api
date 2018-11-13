# frozen_string_literal: true

folders = %w[entities mappers repositories values]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end