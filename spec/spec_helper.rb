require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/mlb_api.rb'

CORRECT = YAML.safe_load(File.read('./fixtures/mlb_results.yml'))
RESPONSE = YAML.load(File.read('./fixtures/mlb_response.yml'))
