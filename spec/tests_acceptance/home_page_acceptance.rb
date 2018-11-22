# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'
require_relative '../helpers/database_helper.rb'
require_relative '../helpers/vcr_helper.rb'
require 'headless'
require 'watir'

describe 'Acceptance Tests' do
  DatabaseHelper.setup_database_cleaner

  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new :firefox
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Homepage' do
    describe 'Visit Homepage' do
      it '(HAPPY) should not see game information if none created' do
        # GIVEN: user is on the home page without any games
        @browser.goto homepage

        # THEN: user should see basic headers, no projects and a welcome message
        _(@browser.h1(id: 'main_header').text).must_equal 'MLBAtBat'
        _(@browser.text_field(id: 'game_date_input').present?).must_equal true
        _(@browser.text_field(id: 'team_name_input').present?).must_equal true
        _(@browser.button(id: 'game_date_submit').present?).must_equal true
        _(@browser.table(id: 'linescore').exists?).must_equal false

        _(@browser.div(id: 'flash_bar_success').present?).must_equal true
        _(@browser.div(id: 'flash_bar_success').text.downcase) \
          .must_include 'started'
      end
    end

    describe 'Add particular game' do
      it '(HAPPY) should see tables after search in subpage' do
        # GIVEN: user is on the home page without any games
        @browser.goto homepage

        # WHEN: they add a project URL and submit
        @browser.text_field(id: 'game_date_input').set(GAME_DATE)
        @browser.text_field(id: 'team_name_input').set(SEARCH_TEAM_NAME)
        @browser.button(id: 'game_date_submit').click

        # WHEN: back to homepage
        Watir::Wait.until do
          @browser.h2(class: 'h2_title').present?
        end
        @browser.goto homepage

        _(@browser.text_field(id: 'game_date_input').present?).must_equal true
        _(@browser.table(id: 'linescore').present?).must_equal true
        _(@browser.table(id: 'games_table').present?).must_equal true
        _(@browser.table(id: 'game_changing_moments').present?).must_equal true
      end
    end
  end
end
