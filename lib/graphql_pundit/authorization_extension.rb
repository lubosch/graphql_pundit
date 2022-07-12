# frozen_string_literal: true

module GraphqlPundit
  # Authorization methods to be included in the used Field class
  class AuthorizationExtension < GraphQL::Schema::FieldExtension
    include GraphqlPundit::Common

    attr_reader :authorize, :policy, :record, :raise_unauthorized

    def initialize(field:, options:)
      super
      @current_user = options[:current_user] || :current_user
    end

    def apply
      @raise_unauthorized = field.raise_unauthorized
      @authorize = field.authorize
      @record = field.record
      @policy = field.policy
      @method_sym = field.method_sym
    end

    def resolve(object:, arguments:, context:, **_rest)
      # yield the current time as `memo`
      raise ::Pundit::NotAuthorizedError unless do_authorize(object, arguments, context)

      yield(object, arguments)
    rescue ::Pundit::NotAuthorizedError
      raise GraphQL::ExecutionError, "You're not authorized to do this" if @raise_unauthorized
    end

    private

    def do_authorize(root, arguments, context)
      return true unless @authorize
      return @authorize.call(root, arguments, context) if callable?(@authorize)

      query = infer_query(@authorize)
      record = infer_record(@record, root, arguments, context)
      policy = infer_policy(@policy, record, arguments, context)

      policy.new(context[@current_user], record).public_send(query)
    end

    def infer_query(auth_value)
      # authorize can be callable, true (for inference) or a policy query
      query = auth_value.equal?(true) ? @method_sym : auth_value
      "#{query}?"
    end

    def infer_record(record, root, arguments, context)
      # record can be callable, nil (for inference) or just any other value
      if callable?(record)
        record.call(root, arguments, context)
      elsif record.equal?(nil)
        root
      else
        record
      end
    end

    def infer_policy(policy, record, arguments, context)
      # policy can be callable, nil (for inference) or a policy class
      if callable?(policy)
        policy.call(record, arguments, context)
      elsif policy.equal?(nil)
        infer_from = model?(record) ? record.model : record
        infer_from = object?(record) ? record.object : infer_from
        ::Pundit::PolicyFinder.new(infer_from).policy!
      else
        policy
      end
    end
  end
end
