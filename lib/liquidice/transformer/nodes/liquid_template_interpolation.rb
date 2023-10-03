module Liquidice
  module Transformer
    module Nodes
      class LiquidTemplateInterpolation < ::Liquidice::Transformer::Nodes::Base
        def transform!
          head, tail, middle = [], [], []

          opening_indent_tokens, closing_indent_tokens = true, false
          children.each do |child|
            if child.is_a?(::Liquidice::Transformer::Nodes::LiquidInterpolationPart)
              middle << child
            elsif child.is_a?(::Liquidice::Transformer::Nodes::HtmlTag)
              child.closing? ? tail << child : head << child
            end
          end

          @children = head + middle + tail
        end

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Children must be present") if children.empty?
        end

        def to_s
          children.map(&:to_s).join
        end
      end
    end
  end
end
