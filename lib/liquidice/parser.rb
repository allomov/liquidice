module Liquidice
  class Parser
    Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'liquidice_grammar.treetop')))

    attr_accessor :strict_mode, :parser, :ast

    def initialize(strict_mode: false)
      @strict_mode = strict_mode
      @parser = LiquidiceGrammarParser.new
    end

    def parse(wysiwyg_template)
      @ast = parser.parse(wysiwyg_template)

      raise Liquidice::Errors::InvalidSyntax, parser.failure_reason if @ast.nil? && strict_mode

      @ast
    end

    def transform(ast)
      root_node = ast&.to_transformer_node
      root_node&.transformer_text_value
    end

    def parse_and_transform(wysiwyg_template)
      transform(parse(wysiwyg_template))
    end
  end
end
