require 'liquidice'

RSpec.describe Liquidice::Transformer::Nodes::LiquidTemplateInterpolation do

  let(:parser) { Liquidice::Parser.new }
  let(:ast) { parser.parse(html_text) }
  let(:transformer) { Liquidice::Transformer::Transformer.new }
  let(:transformer_root_node) { transformer.apply(ast) }
  let(:liquid_template_interpolation_node) do
    transformer_root_node.children.find { |child| child.is_a?(described_class) }
  end

  context "for {<p><img/></p><div>{ var<b>i</b>able <div>}</div></div>} as original text" do
    let(:html_text) do
      <<~HTML
        {<p><img/></p><div>{ var<b>i</b>able <div>}</div></div>}
      HTML
      .strip
    end

    describe '#transform!' do
      it "places opening tags in the begining, interpolation part to the middle and closing tags to the end" do
        liquid_template_interpolation_node.transform!

        expect(liquid_template_interpolation_node.children.map(&:class)).to eq([
          *5.times.map { Liquidice::Transformer::Nodes::HtmlTag },
          *6.times.map { Liquidice::Transformer::Nodes::LiquidInterpolationPart },
          *4.times.map { Liquidice::Transformer::Nodes::HtmlTag }
        ])
      end
    end

    describe '#to_s' do
      it "returns the original text" do
        expect(liquid_template_interpolation_node.to_s).to eq(html_text)
      end

      context "after #transform! is called" do
        before { liquid_template_interpolation_node.transform! }
        let(:transformed_html_text) do
          <<~HTML
            <p><img/><div><b><div>{{ variable }}</p></b></div></div>
          HTML
          .strip
        end

        it "returns the transformed text <p><img/><div><b><div>{{ variable }}</p></b></div></div>" do
          expect(liquid_template_interpolation_node.to_s).to eq(html_text)
        end
      end
    end
  end
end
