require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require 'vcr'
require 'webmock'

require_relative '../lib/mlb_api.rb'

CORRECT = YAML.safe_load(File.read('./fixtures/mlb_results.yml'))
RESPONSE = YAML.load(File.read('./fixtures/mlb_response.yml'))

CASSETTES_FOLDER = './fixtures/cassettes'.freeze
CASSETTE_FILE = 'github_api'.freeze
