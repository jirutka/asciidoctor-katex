# frozen_string_literal: true
require 'asciidoctor/katex/version'

module Asciidoctor::Katex
  # @private
  module Utils
    module_function

    # @param hash [Hash] the hash to transform.
    # @return [Hash] a copy of the *hash* with under_score keys transformed to camelCase.
    def hash_camelize(hash)
      hash.map { |key, val|
        key = key.to_s.gsub(/_\w/) { |s| s[1].upcase }.to_sym
        [key, val]
      }.to_h
    end
  end
end
