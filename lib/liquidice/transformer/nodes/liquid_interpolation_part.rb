module Liquidice
  module Transformer
    module Nodes
      class LiquidInterpolationPart < ::Liquidice::Transformer::Nodes::Base

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Children must be empty, it always must be a leaf node") unless children.empty?
        end
      end
    end
  end
end
