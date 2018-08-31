require_relative 'spec_helper'

require 'asciidoctor/katex/treeprocessor'
require 'asciidoctor'


describe 'Integration Tests' do

  subject(:output) { Asciidoctor.convert(input, options) }

  let(:input) { '' }  # this is modified in #given
  let(:processor) { Asciidoctor::Katex::Treeprocessor.new(**processor_opts) }
  let(:processor_opts) { {} }

  let(:options) {
    processor_ = processor
    {
      safe: :safe,
      header_footer: false,
      extensions: proc { tree_processor processor_ },
      attributes: attributes,
    }
  }
  let(:attributes) { {} }


  shared_examples :unprocessed do |stem_type|
    it "renders #{stem_type} block unprocessed" do
      given <<~ADOC
        [#{stem_type}]
        ++++
        C = \\alpha + \\beta Y^{\\gamma} + \\epsilon
        ++++
      ADOC
      should have_tag 'div.stemblock', text: /C = \\alpha/
      should_not have_tag 'math'
    end

    it "renders inline #{stem_type}:[] unprocessed" do
      given "Do some math: #{stem_type}:[E = mc^2]"

      should have_tag 'p', text: /Do some math:.*E = mc\^2/
    end
  end

  shared_examples :processed do |stem_type|
    it "renders #{stem_type} block processed by KaTeX" do
      given <<~ADOC
        [#{stem_type}]
        ++++
        C = \\alpha + \\beta Y^{\\gamma} + \\epsilon
        ++++
      ADOC
      should have_tag 'div.stemblock'
      should have_tag 'math'
      should_not have_tag '.katex-error'
    end

    it "renders inline #{stem_type}:[] processed by KaTeX" do
      given "Do some math: #{stem_type}:[E = mc^2]"

      should have_tag 'p', text: /^Do some math: /
      should have_tag 'math'
      should_not have_tag '.katex-error'
    end
  end


  context 'document without stem attribute' do
    context 'when config require_stem_attr is true' do
      let(:processor_opts) {{ require_stem_attr: true }}

      ['stem', 'latexmath'].each do |stem_type|
        include_examples :unprocessed, stem_type
      end
    end

    context 'when config require_stem_attr is false' do
      let(:processor_opts) {{ require_stem_attr: false }}

      include_examples :unprocessed, 'stem'
      include_examples :processed, 'latexmath'
    end
  end

  context 'document with :stem: latexmath' do
    let(:attributes) {{ 'stem' => 'latexmath' }}

    include_examples :processed, 'stem'
    include_examples :processed, 'latexmath'

    # Issue #2
    it 'renders inline stem:[] with "<" and ">" processed by KaTeX' do
      given 'Do some math: stem:[a < b > c]'

      should have_tag 'math'
      should have_tag 'mo', text: '<'
      should have_tag 'mo', text: '>'
      should_not have_tag '.katex-error'
    end

    # Issue #3 (affects only JS)
    it 'renders multi-line stem block processed by KaTeX' do
      given <<~ADOC
        [stem]
        ++++
        \\alpha = 42
        \\beta = 55
        ++++
      ADOC
      should have_tag 'math'
      should_not have_tag '.katex-error'
    end
  end


  #----------  Helpers  ----------

  def given(str, opts = {})
    input.replace(str)
    options.merge!(opts)
  end
end
