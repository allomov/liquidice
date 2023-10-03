module Liquidice
  module Transformer
    class Transformer
      def apply(node)
        case node
        when Liquidice::TreetopNodes::LiquidTemplate
          transform_liquid_template(node)
        when Liquidice::TreetopNodes::LiquidTemplateInterpolation
          transform_liquid_template_interpolation(node)
        else
          transform_text_content_node(node)
        end
      end

      def transform_liquid_template(node)
        ::Liquidice::Transformer::Nodes::RootNode.new(
          original_text: node.text_value,
          children: node.elements.flat_map { |element| apply(element) }
        )
      end

      def transform_liquid_template_interpolation(node)
        ::Liquidice::Transformer::Nodes::LiquidTemplateInterpolation.new(
          original_text: node.text_value,
          children: merge_nodes_if_possible(
            node.elements.flat_map do |element|
              transform_liquid_template_interpolation_apply(element)
            end
          )
        )
      end

      def merge_nodes_if_possible(nodes)
        Array(nodes).reduce([]) do |result, node|
          if node.can_be_merged?(result.last)
            result.last.merge(node)
          else
            result << node
          end
          result
        end
      end

      def transform_liquid_template_interpolation_apply(node)
        if node.is_a?(Liquidice::TreetopNodes::HtmlTag)
          transform_html_tag(node)
        elsif node.elements.nil? || node.elements.empty?
          # TODO: add context if it is an opening or closing delimiter
          ::Liquidice::Transformer::Nodes::LiquidInterpolationPart.new(original_text: node.text_value)
        else
          merge_nodes_if_possible(
            node.elements.flat_map do |element|
              transform_liquid_template_interpolation_apply(element)
            end
          )
        end
      end

      def transform_html_tag(node)
        transformer_tag_type = if node.text_value.start_with?('</')
          ::Liquidice::Transformer::Nodes::HtmlTag::CLOSING_TYPE
        elsif node.text_value.end_with?('/>')
          ::Liquidice::Transformer::Nodes::HtmlTag::EMPTY_TYPE
        else
          ::Liquidice::Transformer::Nodes::HtmlTag::OPENING_TYPE
        end

        ::Liquidice::Transformer::Nodes::HtmlTag.new(
          original_text: node.text_value,
          options: {
            type: transformer_tag_type,
          }
        )
      end

      def transform_text_content_node(node)
        if node.elements.nil? || node.elements.empty?
          ::Liquidice::Transformer::Nodes::TextContent.new(original_text: node.text_value)
        else
          merge_nodes_if_possible(
            node.elements.flat_map { |element| apply(element) }
          )
        end
      end

      def transform_text_content(node)
        node.text_value
      end
    end
  end
end
