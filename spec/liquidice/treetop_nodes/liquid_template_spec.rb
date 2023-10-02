require 'liquidice'

RSpec.describe Liquidice::TreetopNodes::LiquidTemplate do
  let(:parser) { Liquidice::Parser.new }
  let(:liquid_template_with_html) do
    <<~HTML
      <div class="wrapper">
        {<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }
        <div>}
      </div>
    HTML
  end
  let(:liquid_template) do
    parser.parse(liquid_template_with_html)
  end

  describe '#to_transformer_node' do
    it 'converts Treetop SyntaxNode to Text and Liquid Template Interpolation nodes of transformer' do
      transformer_node = liquid_template.to_transformer_node
      expect(transformer_node).to be_a Liquidice::Transformer::RootNode
      expect(transformer_node.original_text).to eq liquid_template_with_html
      expect(transformer_node.children).to eq liquid_template_with_html
    end
  end
end
