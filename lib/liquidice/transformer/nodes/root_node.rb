module Liquidice
  module Transformer
    module Nodes
      class RootNode < ::Liquidice::Transformer::Nodes::Base
        def transform!
          children.map(&:transform!)
        end

        def to_s
          children.map(&:to_s)
        end

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Children must be present") if children.empty?
        end
      end
    end
  end
end
