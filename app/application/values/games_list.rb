# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Value
    # List of projects
    GamesList = Struct.new(:games)
  end
end
