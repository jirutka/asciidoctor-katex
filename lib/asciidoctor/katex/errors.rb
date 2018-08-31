# frozen_string_literal: true
require 'asciidoctor/katex/version'

module Asciidoctor::Katex

  # Exception raised when KaTeX throw any error except `ParseError`.
  class KatexError < ::RuntimeError
    attr_reader :expression

    # @param msg [#to_s] the message.
    # @param expression [String] the LaTeX expression that caused the error.
    def initialize(msg, expression)
      @expression = expression
      super(msg.to_s)
    end
  end

  # Exception raised when KaTeX throw `ParseError` which is the main error
  # thrown by KaTeX functions when something has gone wrong.
  class ParseError < KatexError; end
end
