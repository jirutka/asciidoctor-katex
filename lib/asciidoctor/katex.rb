# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/katex/version'
require 'asciidoctor/katex/errors'
require 'asciidoctor/katex/treeprocessor'

unless RUBY_PLATFORM == 'opal'
  Asciidoctor::Extensions.register do
    treeprocessor Asciidoctor::Katex::Treeprocessor
  end
end
