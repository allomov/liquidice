module Liquidice
  module TreetopNodes
    class LiquidTemplateInterpolation < ::Liquidice::TreetopNodes::Base
      def to_transformer_node
        Liquidice::Transformer::Nodes::LiquidTemplateInterpolation.new(
          original_text: text_value,
          children: elements_to_transformer_nodes
        )
      end

      def elements_to_transformer_nodes
        elements.map do |element|
          if element.is_a?(Liquidice::TreetopNodes::Base)
            element.to_transformer_node
          else
            Liquidice::Transformer::Nodes::LiquidInterpolationPart.new(
              original_text: element.text_value
            )
          end
        end
      end
    end
  end
end
