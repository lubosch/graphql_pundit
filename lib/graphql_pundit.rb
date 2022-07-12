# frozen_string_literal: true

require 'graphql'
require 'pundit'

require_relative 'graphql_pundit/version'
require_relative 'graphql_pundit/common'
require_relative 'graphql_pundit/authorization_extension'

module GraphqlPundit
  class Error < StandardError; end
  # Your code goes here...
end
