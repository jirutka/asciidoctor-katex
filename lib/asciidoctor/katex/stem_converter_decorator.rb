# frozen_string_literal: true
require 'asciidoctor/katex/version'
require 'delegate'

module Asciidoctor::Katex
  # The converter decorator that renders delimited math expressions
  # in block and inline latexmath stem nodes after.
  class StemConverterDecorator < ::SimpleDelegator

    # @param converter [Asciidoctor::Converter] the decorated converter to
    #   delegate all method calls to.
    # @param math_renderer [#call] callable that accepts a math expression
    #   [String] and options [Hash], and returns a rendered expression [String].
    def initialize(converter, math_renderer)
      super(converter)
      @math_renderer = math_renderer
      @block_re = regexp_from_delimiters(::Asciidoctor::BLOCK_MATH_DELIMITERS[:latexmath])
      @inline_re = regexp_from_delimiters(::Asciidoctor::INLINE_MATH_DELIMITERS[:latexmath])
    end

    # @param node [Asciidoctor::AbstractNode] the node to convert.
    # @param transform [String, nil] the conversion method to call.
    # @param opts [Hash] options to pass to the converter.
    # @return [String] output of the converter.
    def convert(node, transform = nil, opts = {})
      # Call the underlying converter.
      output = __getobj__.convert(node, transform, opts)

      if latexmath? node
        render_latexmath(output, node)
      else
        output
      end
    end

    protected

    # @param output [String] the converted *node* with delimited math expression.
    # @param node [Asciidoctor::AbstractNode] the AST node.
    # @return [String] a copy of *output* with math expression rendered.
    def render_latexmath(output, node)
      @throw_on_error ||= node.document.attr('katex-throw-on-error', false)
      isblock = node.block?

      output.sub(isblock ? @block_re : @inline_re) do
        math = decode_html_entities(::Regexp.last_match[1].strip)
        @math_renderer.call(math, display_mode: isblock, throw_on_error: @throw_on_error)
      end
    end

    # @param node [Asciidoctor::AbstractNode] the AST node to test.
    # @return [Boolean] `true` if the given *node* is a block or inline latexmath,
    #   `false` otherwise.
    def latexmath?(node)
      case node.node_name
      when 'stem'
        return true if node.style == 'latexmath'
      when 'inline_quoted'
        return true if node.type == :latexmath
      end
      false
    end

    private

    # @param delimiters [Array<String>] tuple with open and close delimiter.
    # @return [Regexp]
    def regexp_from_delimiters(delimiters)
      open, close = delimiters.map { |s| ::Regexp.escape(s) }
      # XXX: `[\s\S]+` is used instead of `.+` for compatibility with Opal.
      /#{open}([\s\S]+)#{close}/m
    end

    # @param str [String]
    # @return [String]
    def decode_html_entities(str)
      str.gsub('&lt;', '<')
        .gsub('&gt;', '>')
        .gsub('&amp;', '&')
    end
  end
end
