require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :test => :spec
  task :default => :spec
rescue LoadError => e
  warn "#{e.path} is not available"
end

begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--display-cop-names', '--fail-level', 'W']
  end

  task :default => :rubocop
rescue LoadError => e
  warn "#{e.path} is not available"
end

task :readme2md do
  require 'asciidoctor'
  require 'pandoc-ruby'

  docbook = Asciidoctor
    .load_file('README.adoc', header_footer: true, backend: 'docbook', attributes: 'npm-readme')
    .convert
  markdown = PandocRuby
    .convert(docbook, from: :docbook, to: :markdown_github, 'base-header-level': 2)

  File.write('README.md', markdown)
end

namespace :build do
  desc 'Transcompile to JavaScript using Opal'
  task :js do
    require 'opal'

    builder = Opal::Builder.new(compiler_options: {
      dynamic_require_severity: :error,
    })
    builder.append_paths 'lib'
    builder.build 'asciidoctor/katex'

    out_file = 'dist/asciidoctor-katex.js'

    mkdir_p(File.dirname(out_file), verbose: false)
    File.open(out_file, 'w') do |file|
      template = File.read('src/asciidoctor-katex.tmpl.js')
      file << template.sub('//OPAL-GENERATED-CODE//') { builder.to_s }
    end
    File.binwrite "#{out_file}.map", builder.source_map
  end
end
