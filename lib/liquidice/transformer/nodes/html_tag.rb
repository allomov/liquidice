module Liquidice
  module Transformer
    module Nodes
      class HtmlTag < ::Liquidice::Transformer::Nodes::Base
        TAG_TYPES = [
          OPENING_TYPE = :opening,
          CLOSING_TYPE = :closing,
          EMPTY_TYPE = :empty
        ].freeze

        def opening?
          type == OPENING_TYPE
        end

        def closing?
          type == CLOSING_TYPE
        end

        def empty?
          type == EMPTY_TYPE
        end

        def type
          @type ||= options[:type]
        end

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Missing :type option") unless options.has_key?(:type)
          raise(Liquidice::Errors::TransformerValidationError, "Children must be empty, it always must be a leaf node") unless children.empty?
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
