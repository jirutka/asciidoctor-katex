# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/katex/version'

module Asciidoctor::Katex
  class Processor < ::Asciidoctor::Extensions::Processor

    # TODO

  end
end
