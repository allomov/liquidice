# Liquidice

Liquidice (Liquid-I-See) to indicate that it is related to part "What I See" of WYSIWYG abbreviation.

Use WYSIWYG editor output with the Liquid templating engine.

### Complications

It is often hard to use Liquid templates with WYSIWYG editor output, becaues WYSIWYG editor may add HTML tags to the template, causing errors.

For example, the Liquid template may be:
```html
{% if wysiwygEditorName %}
  <p>I want Liquid and {{ wysiwygEditorName }} to be friends</p>
{% else %}
  Markdown is awesome too!
{% endif %}
```

And a user of the WYSIWYG editor may enter it using different styles, without realizing it:
```html
  {% <b>if wysiwygEditorName</b> %}
    <p>I want Liquid and {<span>{ wysiwygEdito</span>rName }} to be friends</p>
  {% else %}
    Markdown is awesome too!
  {<div class="useless-div-added-by-wysywig-for-no-reason"></div>% endif %}
```

One possible solution is to move the HTML tags away from the Liquid tags by placing opening tags to the left and closing tags to the right. This would result in the following:
```html
  <b>{% if wysiwygEditorName %}</b>
    <p>I want Liquid and <span>{{ wysiwygEditorName }}</span> to be friends</p>
  {% else %}
    Markdown is awesome too!
  <div class="useless-div-added-by-wysywig-for-no-reason">{% endif %}</div>
```
This modified template is now a valid Liquid template.

### Usage

```ruby
wysiwyg_liquid_template = <<~HTML
  <div class="wrapper">{<div class="c1"></div><div class="c2">{ v</div>a<div class="c3">rName</div>  }<div>}</div>
HTML
# Initialize the parser
parser = Liquidice::Parser.new(strict_mode: true)

# Parse WYSIWYG output to AST
ast = parser.parse_from_wysiwyg(wysiwyg_liquid_template)

# Transform AST to Liquid-compatible code
valid_liquid_template = parser.transform_to_liquid(ast)

# OR Do both in one step
valid_liquid_template = parser.parse_and_transform("<p>{{content}}</p>")

puts valid_liquid_template
# <div class="wrapper"><div class="c1"></div><div class="c2"><div class="c3">{{ varName  }}</div></div><div></div>
```

### Other information

BNF will look in the following way:

```
liquid-template := (liquid-tag | liquid-text)*

body := (liquid-interpolation-content | content-with-tags)*
liquid-interpolation-content := liquid-open-delimeter content-with-tags liquid-close-delimeter
liquid-open-delimeter := liquid-open-delimeter-start any-tag* (liquid-open-delimeter-start | "%")
liquid-close-delimeter := (liquid-close-delimeter-end | "%") any-tag* liquid-close-delimeter-end
liquid-open-delimeter-start := "{"
liquid-close-delimeter-end := "}"

content-with-tags := (any-tag | text-content)*
text-content := (alphabets | digits | dash | ws)*
any-tag := (tag-open | tag-empty | tag-close)
tag-open := '<' tag-name ws* attr-list? ws* '>'
tag-empty := '<' tag-name ws* attr-list? ws* '/>'
tag-close := '</' tag-name ws* '>'

attr-list := (ws+ attr)*
attr := attr-empty | attr-unquoted | attr-single-quoted | attr-double-quoted

attr-empty := attr-name
attr-unquoted := attr-name ws* = ws* attr-unquoted-value
attr-single-quoted := attr-name ws* = ws* ' attr-single-quoted-value '
attr-double-quoted := attr-name ws* = ws* " attr-double-quoted-value "

tag-name := (alphabets | digits | dash)+                      # Can digits become first letter?
attr-name := /[^\s"'>/=\p{Control}]+/

# These three items should not contain 'ambiguous ampersand'...
attr-unquoted-value := /[^\s"'=<>`]+/
attr-single-quoted-value := /[^']*/
attr-double-quoted-value := /[^"]*/

alphabets := /[a-zA-Z]/
digits := /[0-9]/
ws := /\s/
dash := '-'
```

you can use treetop or racc gems to generate parser from BNF; probably treetop will be easier to adapt

after that you need to write a transformer that will convert AST to valid liquid template

add ruby gitingore to .gitignore
