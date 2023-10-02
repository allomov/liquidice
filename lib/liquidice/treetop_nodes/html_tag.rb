module Liquidice
  module TreetopNodes
    class HtmlTag < ::Liquidice::TreetopNodes::Base
      def to_transformer_node
        ::Liquidice::Transformer::Nodes::Tag.new(
          original_text: text_value,
          options: {
            type: transformer_tag_type,
          }
        )
      end

      def transformer_tag_type
        ::Liquidice::Transformer::Nodes::Tag::OPENING_TYPE
      end
    end
  end
end
