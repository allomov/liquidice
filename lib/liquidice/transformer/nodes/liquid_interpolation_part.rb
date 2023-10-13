module Liquidice
  module Transformer
    module Nodes
      class LiquidInterpolationPart < ::Liquidice::Transformer::Nodes::Base
        TYPES = [
          OPEN_DELIMITER_TYPE = :open_delimiter,
          CLOSE_DELIMITER_TYPE = :close_delimiter,
          INTERPOLATION_CONTENT_TYPE = :interpolation_content
        ].freeze

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Children must be empty, it always must be a leaf node") unless children.empty?
        end

        def open_delimiter?
          type == OPEN_DELIMITER_TYPE
        end

        def close_delimiter?
          type == CLOSE_DELIMITER_TYPE
        end

        def interpolation_content?
          type == INTERPOLATION_CONTENT_TYPE
        end

        def type
          @type ||= options[:type]
        end

        def merge(other)
          @original_text += other.original_text
        end

        def can_be_merged?(other)
          other.is_a?(::Liquidice::Transformer::Nodes::LiquidInterpolationPart) && type == other.type
        end

        def text_value
          @original_text
        end

        def to_s
          @original_text
        end
      end
    end
  end
end
