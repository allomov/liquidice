module Liquidice
  module Transformer
    module Nodes
      class Tag < ::Liquidice::Transformer::Nodes::Base
        TAG_TYPES = [
          OPENING_TYPE = :opening,
          CLOSING_TYPE = :closing,
          EMPTY_TYPE = :empty
        ].freeze

        def opening?
          options[:type] == OPENING_TYPE
        end

        def closing?
          options[:type] == CLOSING_TYPE
        end

        def empty?
          options[:type] == EMPTY_TYPE
        end

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Missing :type option") unless options.has_key?(:type)
          raise(Liquidice::Errors::TransformerValidationError, "Children must be empty, it always must be a leaf node") unless children.empty?
        end
      end
    end
  end
end
