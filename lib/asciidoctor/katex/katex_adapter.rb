# frozen_string_literal: true
require 'asciidoctor/katex/version'
require 'katex' unless RUBY_PLATFORM == 'opal'

module Asciidoctor::Katex
  # Adapter for KaTeX library supporting both Ruby and Opal environment.
  class KatexAdapter

    # @param default_options [Hash] the default options for the KaTeX renderer.
    # @param katex_object the katex object to use under Opal (defaults to
    #   global variable `katex`).
    def initialize(default_options = {}, katex_object = nil)
      @default_options = default_options
      @katex_object = katex_object || `katex` if RUBY_PLATFORM == 'opal'
    end

    # @return [Boolean] whether is KaTeX library installed and loaded.
    #   This is useful only under Opal.
    def available?
      if RUBY_PLATFORM == 'opal'
        `#{@katex_object} != 'undefined' && #{@katex_object}.renderToString != undefined`
      else
        defined? ::Katex
      end
    end

    # Renders the given math expression to HTML using KaTeX.
    #
    # @param math [String] the math (LaTeX) expression.
    # @param options [Hash] options for `katex.renderToString`.
    #   Keys in under_score notation will be converted to camelCase.
    #   See <https://github.com/Khan/KaTeX#rendering-options>.
    # @return [String] a rendered HTML fragment.
    def render(math, options = {})
      options = hash_camelize(options || {})

      if RUBY_PLATFORM == 'opal'
        `#{@katex_object}.renderToString(#{math}, #{options}.$$smap)`
      else
        ::Katex.render(math, options)
      end
    end

    alias call render

    # @return [String] version of the KaTeX library.
    def version
      if RUBY_PLATFORM == 'opal'
        '0.9.0'  # TODO: replace with `katex.version` after update to 0.10+.
      else
        ::Katex::KATEX_VERSION.sub(/^v/, '')
      end
    end

    private

    # @param hash [Hash] the hash to transform.
    # @return [Hash] a copy of the *hash* with under_score keys transformed to camelCase.
    def hash_camelize(hash)
      hash.map { |k, v|
        [k.to_s.gsub(/_\w/) { |s| s[1].upcase }.to_sym, v]
      }.to_h
    end
  end
end
