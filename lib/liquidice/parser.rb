require 'treetop'

module Liquidice
  class Parser
    def initialize(strict_mode: false)
      @strict_mode = strict_mode
    end

    def parse_from_wysiwyg(wysiwyg_template)
      # Parse the WYSIWYG template using the Liquidice grammar
      parser = LiquidiceGrammarParser.new
      ast = parser.parse(wysiwyg_template)

      if ast.nil?
        raise "Invalid WYSIWYG template"
      end

      ast
    end

    def transform_to_liquid(ast)
      # Transform the AST to a valid Liquid template
      transformer = Transformer.new
      transformer.apply(ast)
    end

    def parse_and_transform(wysiwyg_template)
      ast = parse_from_wysiwyg(wysiwyg_template)
      transform_to_liquid(ast)
    end
  end
end
