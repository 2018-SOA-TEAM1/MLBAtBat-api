# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init.rb'

SPORT_ID = 1.freeze
CORRECT = YAML.safe_load(File.read('spec/fixtures/mlb_results.yml'))
RESPONSE = YAML.load(File.read('spec/fixtures/mlb_response.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'mlb_api'
