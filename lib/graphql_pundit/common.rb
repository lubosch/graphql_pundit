# frozen_string_literal: true

module GraphqlPundit
  # Common methods used for authorization and scopes
  module Common
    def callable?(thing)
      thing.respond_to?(:call)
    end

    def model?(thing)
      thing.respond_to?(:model)
    end

    def object?(thing)
      thing.respond_to?(:object)
    end
  end
end
