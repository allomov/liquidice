module Liquidice
  class Transformer < Treetop::Runtime::SyntaxNode
    def apply(node)
      case node
      when LiquidiceGrammarParser::LiquidTemplate
        transform_liquid_template(node)
      when LiquidiceGrammarParser::LiquidTag
        transform_liquid_tag(node)
      when LiquidiceGrammarParser::LiquidOpenDelimeter
        transform_liquid_open_delimeter(node)
      when LiquidiceGrammarParser::LiquidCloseDelimeter
        transform_liquid_close_delimeter(node)
      when LiquidiceGrammarParser::ContentWithTags
        transform_content_with_tags(node)
      when LiquidiceGrammarParser::TextContent
        transform_text_content(node)
      when LiquidiceGrammarParser::AnyTag
        transform_any_tag(node)
      when LiquidiceGrammarParser::TagOpen
        transform_tag_open(node)
      when LiquidiceGrammarParser::TagEmpty
        transform_tag_empty(node)
      when LiquidiceGrammarParser::TagClose
        transform_tag_close(node)
      when LiquidiceGrammarParser::AttrList
        transform_attr_list(node)
      when LiquidiceGrammarParser::Attr
        transform_attr(node)
      when LiquidiceGrammarParser::AttrEmpty
        transform_attr_empty(node)
      when LiquidiceGrammarParser::AttrUnquoted
        transform_attr_unquoted(node)
      when LiquidiceGrammarParser::AttrSingleQuoted
        transform_attr_single_quoted(node)
      when LiquidiceGrammarParser::AttrDoubleQuoted
        transform_attr_double_quoted(node)
      when LiquidiceGrammarParser::TagName
        transform_tag_name(node)
      when LiquidiceGrammarParser::AttrName
        transform_attr_name(node)
      when LiquidiceGrammarParser::AttrUnquotedValue
        transform_attr_unquoted_value(node)
      when LiquidiceGrammarParser::AttrSingleQuotedValue
        transform_attr_single_quoted_value(node)
      when LiquidiceGrammarParser::AttrDoubleQuotedValue
        transform_attr_double_quoted_value(node)
      when LiquidiceGrammarParser::Alphabets
        transform_alphabets(node)
      when LiquidiceGrammarParser::Digits
        transform_digits(node)
      when LiquidiceGrammarParser::Ws
        transform_ws(node)
      when LiquidiceGrammarParser::Dash
        transform_dash(node)
      else
        raise "Invalid AST node"
      end
    end

    def transform_liquid_template(node)
      node.elements.map { |element| apply(element) }.join
    end

    def transform_liquid_tag(node)
      "{{ " + apply(node.content_with_tags) + " }}"
    end

    def transform_liquid_open_delimeter(node)
      "{% "
    end

    def transform_liquid_close_delimeter(node)
      " %}"
    end

    def transform_content_with_tags(node)
      node.elements.map { |element| apply(element) }.join
    end

    def transform_text_content(node)
      node.text_value
    end

    def transform_any_tag(node)
      apply(node.tag_open) || apply(node.tag_empty) || apply(node.tag_close)
    end

    def transform_tag_open(node)
      node.text_value
    end

    def transform_tag_empty(node)
      node.text_value
    end

    def transform_tag_close(node)
      node.text_value
    end

    def transform_attr_list(node)
      node.elements.map { |element| apply(element) }.join
    end

    def transform_attr(node)
      apply(node.attr_empty) || apply(node.attr_unquoted) || apply(node.attr_single_quoted) || apply(node.attr_double_quoted)
    end

    def transform_attr_empty(node)
      node.text_value
    end

    def transform_attr_unquoted(node)
      node.text_value
    end

    def transform_attr_single_quoted(node)
      node.text_value
    end

    def transform_attr_double_quoted(node)
      node.text_value
    end

    def transform_tag_name(node)
      node.text_value
    end

    def transform_attr_name(node)
      node.text_value
    end

    def transform_attr_unquoted_value(node)
      node.text_value
    end

    def transform_attr_single_quoted_value(node)
      node.text_value
    end

    def transform_attr_double_quoted_value(node)
      node.text_value
    end

    def transform_alphabets(node)
      node.text_value
    end

    def transform_digits(node)
      node.text_value
    end

    def transform_ws(node)
      node.text_value
    end

    def transform_dash(node)
      node.text_value
    end
  end
end
