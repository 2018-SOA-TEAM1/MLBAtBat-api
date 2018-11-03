# frozen_string_literal: true

folders = %w[entities gateways mappers repositories]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
