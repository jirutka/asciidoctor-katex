require_relative 'spec_helper'

require 'asciidoctor/katex/processor'
require 'asciidoctor'


describe 'Integration Tests' do

  subject(:output) { Asciidoctor.convert(input, options) }

  let(:input) { '' }  # this is modified in #given

  let(:options) {
    {
      safe: :safe,
      header_footer: false,
    }
  }


  # TODO


  #----------  Helpers  ----------

  def given(str, opts = {})
    input.replace(str)
    options.merge!(opts)
  end
end
