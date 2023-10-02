module Liquidice
  module Transformer
    module Nodes
      # The base node
      class Base
        attr_reader :original_text, :children, :options

        def intialize(original_text:, children: [], options: {})
          @original_text, @children, @options = original_text, children, options

          validate!
        end

        def to_s
          children.map(&:to_s).join
        end

        def transform!
          # do nothing
        end

        def validate!
          # do nothing
        end
      end
    end
  end
end
