# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url MLBAtBat::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:notice_message, id: 'flash_bar_notice')

  h1(:title_heading, id: 'main_header')
  text_field(:date_input, id: 'datepicker')
  text_field(:team_name_input, id: 'team_name_input')
  button(:search_button, id: 'game_date_submit')

  table(:linescore_table, id: 'linescore')
  table(:games_table, id: 'games_table')
  table(:gcms_table, id: 'game_changing_moments')

  # unused now
  indexed_property(
    :linescore_table,
    [
      [:span, :home_inning_scores, { id: 'inning[%s].home_score' }]
    ]
  )

  def search_new_game(date, team_name)
    self.date_input = date
    self.team_name_input = team_name
    search_button
  end

  def home_scores
    linescore_table_element.tr(id: 'home_linescore').tds
      .select do |col|
      col.class_name == 'home score'
    end
  end

  def gcms
    @browser.table(id: 'game_changing_moments').trs
      .select do |col|
      col.td(class: %w[td_inning]).present? &&
        col.td(class: %w[td_event]).present? &&
        col.td(class: %w[td_description]).present?
    end
  end
end
