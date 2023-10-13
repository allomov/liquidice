module Treetop
  module Runtime
    class SyntaxNode
      def has_ascendant?(type:, stop_node_type: Liquidice::TreetopNodes::LiquidTemplate)
        return false if parent.nil?
        return false if self.is_a?(stop_node_type)

        parent.is_a?(type) || parent.has_ascendant?(type: type, stop_node_type: stop_node_type)
      end
    end
  end
end
