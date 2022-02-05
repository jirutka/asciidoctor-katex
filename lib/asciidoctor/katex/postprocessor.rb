# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'

module Asciidoctor::Katex
  # Asciidoctor processor that removes MathJax `script` tags, produced by the
  # Asciidcotor's built-in HTML converter, from the converted document.
  class Postprocessor < Asciidoctor::Extensions::Postprocessor

    # @param output [String] the converted document.
    # @return [String] a modified *output*.
    def process(_, output)
      output
        .sub(%r{<script type="text/x-mathjax-config">.*?</script>}m, '')  # FIXME: broken in JS
        .sub(%r{<script src=".*?/MathJax\.js\?config=TeX-MML-AM_HTMLorMML"></script>}, '')
    end
  end
end
