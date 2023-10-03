module Liquidice
  class Parser
    Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'liquidice_grammar.treetop')))

    attr_accessor :strict_mode, :parser, :ast, :transformed_ast, :transformer

    def initialize(strict_mode: false)
      @strict_mode = strict_mode
      @parser = LiquidiceGrammarParser.new
      @transformer = Liquidice::Transformer::Transformer.new
    end

    def parse(wysiwyg_template)
      @ast = parser.parse(wysiwyg_template)

      raise Liquidice::Errors::InvalidSyntax, parser.failure_reason if @ast.nil? && strict_mode

      @ast
    end

    def transform
      @transformed_ast = transformer.apply(ast)
    end

    def parse_and_transform(wysiwyg_template)
      parse(wysiwyg_template)
      transform
      transformed_ast.to_s
    end
  end
end
