# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/katex/version'
require 'asciidoctor/katex/processor'

Asciidoctor::Extensions.register do
  # TODO
end
