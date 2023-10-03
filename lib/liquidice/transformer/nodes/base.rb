module Liquidice
  module Transformer
    module Nodes
      # The base node
      class Base
        attr_reader :original_text, :children, :options

        def initialize(original_text:, children: [], options: {})
          @original_text, @children, @options = original_text, children, options

          validate!
        end

        def to_s
          raise NotImplementedError
        end

        def transform!
          # do nothing
        end

        def validate!
          # do nothing
        end

        def can_be_merged?(other)
          false
        end
      end
    end
  end
end
