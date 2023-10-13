module Liquidice
  module Transformer
    module Nodes
      class LiquidTemplateInterpolation < ::Liquidice::Transformer::Nodes::Base
        def transform!
          head, tail, middle = [], [], []

          current_interpolation_part_context = ::Liquidice::Transformer::Nodes::LiquidInterpolationPart::OPEN_DELIMITER_TYPE
          children.each do |child|
            if child.is_a?(::Liquidice::Transformer::Nodes::LiquidInterpolationPart)
              middle << child
              current_interpolation_part_context = child.type
            elsif child.is_a?(::Liquidice::Transformer::Nodes::HtmlTag)
              if current_interpolation_part_context == ::Liquidice::Transformer::Nodes::LiquidInterpolationPart::OPEN_DELIMITER_TYPE
                head << child
              elsif current_interpolation_part_context == ::Liquidice::Transformer::Nodes::LiquidInterpolationPart::INTERPOLATION_CONTENT_TYPE
                child.opening? ? head << child : tail << child
              elsif current_interpolation_part_context == ::Liquidice::Transformer::Nodes::LiquidInterpolationPart::CLOSE_DELIMITER_TYPE
                tail << child
              else
                raise "Unknown interpolation part context: #{current_interpolation_part_context}"
              end
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
