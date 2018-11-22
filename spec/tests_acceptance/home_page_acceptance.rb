# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/home_page.rb'

describe 'Acceptance Tests' do
  include PageObject::PageFactory

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
        visit HomePage do |page|
          _(page.title_heading).must_equal 'MLBAtBat'
          _(page.date_input_element.present?).must_equal true
          _(page.team_name_input_element.present?).must_equal true
          _(page.search_button_element.present?).must_equal true
          _(page.linescore_table_element.exists?).must_equal false

          _(page.notice_message_element.present?).must_equal true
          _(page.notice_message.downcase).must_include 'started'
        end
      end
    end

    describe 'Add particular game' do
      it '(HAPPY) should see tables after search in subpage' do
        visit HomePage do |page|
          good_date = GAME_DATE
          good_team_name = SEARCH_TEAM_NAME
          page.search_new_game(good_date, good_team_name)
        end

        # WHEN: back to homepage
        Watir::Wait.until do
          @browser.h2(class: 'h2_title').present?
        end
        visit HomePage do |page|
          _(page.linescore_table_element.exists?).must_equal true
          _(page.games_table_element.exists?).must_equal true
          _(page.gcms_table_element.exists?).must_equal true

          # THEN: user should see correct # of innings' scores
          _(page.home_scores.count).must_equal 9

          # THEN: user should see correct # of gcms
          _(page.gcms.count).must_equal 3
        end
      end
    end
  end
end
