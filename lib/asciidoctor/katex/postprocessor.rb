# frozen_string_literal: true
require 'asciidoctor' unless RUBY_PLATFORM == 'opal'
require 'asciidoctor/extensions' unless RUBY_PLATFORM == 'opal'

module Asciidoctor::Katex
  # Asciidoctor processor that removes MathJax `script` tags, produced by the
  # Asciidcotor's built-in HTML converter, from the converted document.
  class Postprocessor < Asciidoctor::Extensions::Postprocessor

    # @param document [Asciidoctor::Document] the document to process.
    # @param output [String] the converted document.
    # @return [String] a modified *output*`.
    def process(document, output)
      return output if skip? document

      output
        .sub(%r{<script type="text/x-mathjax-config">.*?</script>}m, '')  # FIXME: broken in JS
        .sub(%r{<script src=".*?/MathJax\.js\?config=TeX-MML-AM_HTMLorMML"></script>}, '')
    end

    protected

    # @param document [Asciidoctor::Document] the document to process.
    # @return [Boolean] whether to skip processing of the *document*.
    def skip?(document)
      document.backend != 'html5'
    end
  end
end
