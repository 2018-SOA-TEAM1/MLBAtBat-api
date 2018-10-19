# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require 'vcr'
require 'webmock'

require_relative '../lib/mlb_api.rb'

CORRECT = YAML.safe_load(File.read('spec/fixtures/mlb_results.yml'))
RESPONSE = YAML.load(File.read('spec/fixtures/mlb_response.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'mlb_api'
