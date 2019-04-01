require File.expand_path('../lib/asciidoctor/katex/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'asciidoctor-katex'
  s.version     = Asciidoctor::Katex::VERSION
  s.author      = 'Jakub Jirutka'
  s.email       = 'jakub@jirutka.cz'
  s.homepage    = 'https://github.com/jirutka/asciidoctor-katex/'
  s.license     = 'MIT'

  s.summary     = 'Asciidoctor extension that converts latexmath to HTML using KaTeX at build-time'

  s.files       = Dir['lib/**/*', '*.gemspec', 'LICENSE*', 'README*']

  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'asciidoctor', '>= 1.5.6', '< 3.0'
  s.add_runtime_dependency 'katex', '~> 0.4.3'

  s.add_development_dependency 'kramdown', '~> 1.17'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rspec-html-matchers', '~> 0.9.1'
  s.add_development_dependency 'rubocop', '~> 0.51.0'
  s.add_development_dependency 'simplecov', '~> 0.16'
  s.add_development_dependency 'yard', '~> 0.9'
end
