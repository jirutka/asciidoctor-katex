# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/katex/version'
require 'asciidoctor/katex/stem_converter_decorator'

if RUBY_PLATFORM == 'opal'
  require 'asciidoctor/katex/opal_katex_adapter'
else
  require 'asciidoctor/katex/ruby_katex_adapter'
end

module Asciidoctor::Katex
  # Asciidoctor processor that renders delimited latexmath expressions using
  # the KaTeX library.
  class Treeprocessor < ::Asciidoctor::Extensions::Treeprocessor

    # @param katex_options [Hash] default options for the KaTeX renderer.
    #   This parameter has no effect when *katex_renderer* is provided.
    # @param katex_renderer [#call, nil] callable that accepts a math expression
    #   [String] and options [Hash], and returns a rendered expression [String].
    #   Defaults to {KatexAdapter} initialized with the *katex_options*.
    # @param require_stem_attr [Boolean] `true` to skip when `stem` attribute
    #   is not declared, `false` to process anyway.
    def initialize(katex_options: {}, katex_renderer: nil, require_stem_attr: true, **)
      @katex_renderer = katex_renderer || KatexAdapter.new(katex_options)
      @require_stem_attr = require_stem_attr
      super
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
