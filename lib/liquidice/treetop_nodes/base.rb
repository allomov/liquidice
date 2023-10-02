module Liquidice
  module TreetopNodes
    # The base node
    class Base < ::Treetop::Runtime::SyntaxNode
      # this is only an abstract method
      def to_transformer_node
        raise NotImplementedError, "abstract method"
      end
    end
  end
end
