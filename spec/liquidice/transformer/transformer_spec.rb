require 'liquidice'

RSpec.describe Liquidice::Transformer::Transformer do
  let(:parser) { Liquidice::Parser.new }
  let(:ast) { parser.parse(text) }

  let(:transformer) do
    described_class.new
  end

  describe '#apply' do
    context "without liquid template interpolation" do
      let(:text) do
        <<~HTML
          <div class="wrapper">Some html <b>text</b></div><br/>
        HTML
      end

      it "returns one TextContent node with the content that is the same with input text" do
        result = transformer.apply(ast)
        expect(result.children.size).to eq(1)
        content_node = result.children.first
        expect(content_node).to be_a Liquidice::Transformer::Nodes::TextContent
        expect(content_node.children).to be_empty
        expect(content_node.original_text).to eq(text)
      end
    end

    context "with liquid template interpolation" do
      let(:text) do
        <<~HTML
          <div class="wrapper">
            {<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }
            <div>}
          </div>
        HTML
      end

      it 'converts Treetop SyntaxNode to Transformer Tree' do
        result = transformer.apply(ast)
        expect(result.children.map(&:class)).to eq([
          Liquidice::Transformer::Nodes::TextContent,
          Liquidice::Transformer::Nodes::LiquidTemplateInterpolation,
          Liquidice::Transformer::Nodes::TextContent
        ])
        expect(result.children.map(&:original_text)).to eq([
          "<div class=\"wrapper\">\n  ",
          "{<div class=\"c1\"></div><div class=\"c2\">{ v</div>a<div class=\"c3\">rName</div>  }\n  <div>}",
          "\n</div>\n"
        ])

        liquid_template_interpolation_node = result.children[1]

        expect(liquid_template_interpolation_node.children.map(&:class)).to eq([
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart,
          Liquidice::Transformer::Nodes::HtmlTag,
          Liquidice::Transformer::Nodes::LiquidInterpolationPart
        ])

        expect(liquid_template_interpolation_node.children.map(&:type)).to eq([
          :open_delimiter,
          :opening,
          :closing,
          :opening,
          :open_delimiter,
          :interpolation_content,
          :closing,
          :interpolation_content,
          :opening,
          :interpolation_content,
          :closing,
          :interpolation_content,
          :close_delimiter,
          :opening,
          :close_delimiter
        ])

        expect(liquid_template_interpolation_node.children.map(&:original_text)).to eq([
          "{",
          "<div class=\"c1\">",
          "</div>",
          "<div class=\"c2\">",
          "{",
          " v",
          "</div>",
          "a",
          "<div class=\"c3\">",
          "rName",
          "</div>",
          "  ",
          "}\n  ",
          "<div>",
          "}"
        ])
      end
    end
  end
end
