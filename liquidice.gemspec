# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquidice/version'

Gem::Specification.new do |spec|
  spec.name          = 'liquidice'
  spec.version       = Liquidice::Version::STRING
  spec.authors       = ['Aliaksandr Lomau']
  spec.email         = ['aliaksandr.lomau@gmail.com']
  spec.summary       = 'Allows the use of Liquid templates with WYSIWYG editor output'
  spec.description   = <<~EOF
    Liquidice (Liquid-I-See) - enables the use of Liquid templates with WYSIWYG editor output by transforming
    the output to a valid Liquid template
  EOF
  spec.homepage      = 'https://github.com/allomov/liquidice'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'treetop', '~> 1.4'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
