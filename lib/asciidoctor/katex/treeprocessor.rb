# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/katex/version'
require 'asciidoctor/katex/katex_adapter'
require 'asciidoctor/katex/stem_converter_decorator'

module Asciidoctor::Katex
  # Asciidoctor processor that renders delimited latexmath expressions using
  # the KaTeX library.
  class Treeprocessor < ::Asciidoctor::Extensions::Treeprocessor

    # @param katex_renderer [#call] callable that accepts a math expression
    #   [String] and options [Hash], and returns a rendered expression [String].
    #   Default is an instance of KatexAdapter.
    # @param require_stem_attr [Boolean] `true` to skip when `stem` attribute
    #   is not declared, `false` to process anyway.
    def initialize(katex_renderer: KatexAdapter.new,
                   require_stem_attr: true,
                   **)
      super
      @katex_renderer = katex_renderer
      @require_stem_attr = require_stem_attr
    end

    # @param document [Asciidoctor::Document] the document to process.
    def process(document)
      return if skip? document

      converter = document.instance_variable_get(:@converter)
      decorator = StemConverterDecorator.new(converter, @katex_renderer)
      document.instance_variable_set(:@converter, decorator)
      nil
    end

    protected

    # @param document [Asciidoctor::Document] the document to process.
    # @return [Boolean] whether to skip processing of the *document*.
    def skip?(document)
      @require_stem_attr && !document.attr?('stem')
    end
  end
end
