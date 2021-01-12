# frozen_string_literal: true
require 'asciidoctor/katex/version'
require 'asciidoctor/katex/errors'
require 'asciidoctor/katex/utils'

module Asciidoctor::Katex
  # Adapter for the KaTeX library for Opal/JS environment.
  class OpalKatexAdapter
    include Utils

    # @param default_options [Hash] the default options for the KaTeX renderer.
    # @param katex_object the katex object to use under Opal (defaults to
    #   global variable `katex`).
    def initialize(default_options = {}, katex_object = nil)
      @default_options = hash_camelize(default_options)
      @katex_object = katex_object || `katex`
    end

    # Renders the given math expression to HTML using KaTeX.
    #
    # @param math [String] the math (LaTeX) expression.
    # @param opts [Hash] options for `katex.renderToString`.
    #   Keys in under_score notation will be converted to camelCase.
    #   See <https://github.com/Khan/KaTeX#rendering-options>.
    # @return [String] a rendered HTML fragment.
    def render(math, opts = {})
      opts = @default_options.merge(hash_camelize(opts))

      begin
        `#{@katex_object}.renderToString(#{math}, #{opts}.$$smap)`
      rescue ::JS::Error => e
        # rubocop:disable Style/RedundantInterpolation
        # "#{e}" is really needed for Opal/JS, #to_s returns a different string.
        raise ParseError.new(e, math) if "#{e}".start_with?('ParseError:')

        raise KatexError.new(e, math)
        # rubocop:enable Style/RedundantInterpolation
      end
    end

    alias call render
  end

  # The default KaTeX adapter.
  KatexAdapter = OpalKatexAdapter unless defined? KatexAdapter
end
