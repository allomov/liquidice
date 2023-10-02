require 'liquidice'

RSpec.describe Liquidice::Parser do
  let(:parser) { Liquidice::Parser.new }

  describe '#parse_from_wysiwyg' do
    context 'when the WYSIWYG template is valid' do
      it 'returns the AST' do
        wysiwyg_template = '<div class="wrapper">{<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }<div>}</div>'

        ast = parser.parse(wysiwyg_template)

        expect(ast).not_to be_nil
      end
    end

    context 'when the WYSIWYG template is invalid' do
      it 'raises an error' do
        wysiwyg_template = '<div class="wrapper">{<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }<div>'

        expect { parser.parse(wysiwyg_template) }.to raise_error Liquidice::Errors::InvalidSyntax
      end
    end
  end

  describe '#transform_to_liquid' do
    it 'transforms the AST to a valid Liquid template' do
      ast = LiquidiceGrammarParser.new.parse('<div class="wrapper">{<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }<div>}</div>')

      liquid_template = parser.transform_to_liquid(ast)

      expect(liquid_template).to eq('<div class="wrapper"><div class="c1"></div><div class="c2"><div class="c3">{{ rName }}</div></div><div></div>')
    end
  end

  describe '#parse_and_transform' do
    it 'parses the WYSIWYG template and transforms it to a valid Liquid template' do
      wysiwyg_template = '<div class="wrapper">{<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }<div>}</div>'

      liquid_template = parser.parse_and_transform(wysiwyg_template)

      expect(liquid_template).to eq('<div class="wrapper"><div class="c1"></div><div class="c2"><div class="c3">{{ rName }}</div></div><div></div>')
    end
  end
end
