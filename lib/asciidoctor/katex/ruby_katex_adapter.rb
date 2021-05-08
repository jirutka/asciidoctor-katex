# frozen_string_literal: true
require 'asciidoctor/katex/version'
require 'asciidoctor/katex/errors'
require 'asciidoctor/katex/utils'
require 'katex'

module Asciidoctor::Katex
  # Adapter for the KaTeX library for Ruby environment.
  class RubyKatexAdapter
    include Utils

    # @param default_options [Hash] the default options for the KaTeX renderer.
    def initialize(default_options = {})
      @default_options = hash_camelize(default_options)
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

      opts[:throw_on_error] = opts[:throwOnError]
      opts[:error_color] = opts[:errorColor] || '#cc0000'

      begin
        ::Katex.render(math, **opts)
      rescue ::ExecJS::ProgramError => err
        raise ParseError.new(err, math) if err.to_s.start_with?('ParseError:')
        raise KatexError.new(err, math)
      end
    end

    alias call render
  end

  # The default KaTeX adapter.
  KatexAdapter = RubyKatexAdapter unless defined? KatexAdapter
end
