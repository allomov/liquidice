module Liquidice
  module Transformer
    module Nodes
      class TextContent < ::Liquidice::Transformer::Nodes::Base
        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Children must be empty, it always must be a leaf node") unless children.empty?
        end

        def merge(other)
          @original_text += other.original_text
        end

        def text_value
          @original_text
        end

        def can_be_merged?(other)
          other.is_a?(::Liquidice::Transformer::Nodes::TextContent)
        end

        def to_s
          @original_text
        end
      end
    end
  end
end
