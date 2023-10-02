module Liquidice
  module Errors
    class Base < StandardError; end
    class InvalidSyntax < Base; end
    class TransformerValidationError < Base; end
  end
end
