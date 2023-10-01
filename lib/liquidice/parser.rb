require 'treetop'

module Liquidice
  class Parser
    Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'liquidice_grammar.treetop')))

    attr_accessor :strict_mode, :parser, :ast

    def initialize(strict_mode: false)
      @strict_mode = strict_mode
      @parser = LiquidiceGrammarParser.new
    end

    def parse_from_wysiwyg(wysiwyg_template)
      @ast = parser.parse(wysiwyg_template)

      raise Liquidice::Errors::InvalidWysiwygTemplate, parser.failure_reason if @ast.nil?

      @ast
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
