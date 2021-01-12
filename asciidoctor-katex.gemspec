require File.expand_path('lib/asciidoctor/katex/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'asciidoctor-katex'
  s.version     = Asciidoctor::Katex::VERSION
  s.author      = 'Jakub Jirutka'
  s.email       = 'jakub@jirutka.cz'
  s.homepage    = 'https://github.com/jirutka/asciidoctor-katex/'
  s.license     = 'MIT'

  s.summary     = 'Asciidoctor extension that converts latexmath to HTML using KaTeX at build-time'

  s.files       = Dir['lib/**/*', '*.gemspec', 'LICENSE*', 'README.adoc']

  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'asciidoctor', '>= 1.5.6', '< 3.0'
  s.add_runtime_dependency 'katex', '~> 0.6'

  s.add_development_dependency 'kramdown', '~> 2.3.0'
  s.add_development_dependency 'pandoc-ruby', '~> 2.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rspec-html-matchers', '~> 0.9.1'
  s.add_development_dependency 'rubocop', '~> 1.8.1'
  s.add_development_dependency 'rubocop-rake', '~> 0.5.1'
  s.add_development_dependency 'rubocop-rspec', '~> 2.1.0'
  s.add_development_dependency 'simplecov', '~> 0.16'
  s.add_development_dependency 'yard', '~> 0.9'
end
