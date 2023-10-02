module Liquidice
  module Transformer
    module Nodes
      class LiquidTemplateInterpolation < ::Liquidice::Transformer::Nodes::Base
        def transform!
          head = [], tail = [], middle = []

          children.each do |child|
            if child.is_a?(Liquidice::TreetopNodes::LiquidInterpolationPart)
              middle << children
            elsif child.is_a?(Liquidice::TreetopNodes::HtmlTag)
              child.closing? ? tail << child : head << child
            end
          end

          children = head + middle + tail
        end

        def validate!
          raise(Liquidice::Errors::TransformerValidationError, "Children must be present") if children.empty?
        end
      end
    end
  end
end
