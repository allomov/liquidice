module Liquidice
  module TreetopNodes
    class LiquidTemplate < ::Liquidice::TreetopNodes::Base
      def to_transformer_node
        ::Liquidice::Transformer::Nodes::RootNode.new(
          original_text: text_value,
          children: elements_to_transformer_nodes
        )
      end

      def elements_to_transformer_nodes
        elements.map do |element|
          if element.is_a?(Liquidice::TreetopNodes::Base)
            element.to_transformer_node
          else
            ::Liquidice::Transformer::Nodes::TextContent.new(
              original_text: element.text_value
            )
          end
        end
      end
    end
  end
end
