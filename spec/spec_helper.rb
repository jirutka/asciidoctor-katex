require 'rspec'
require 'rspec-html-matchers'

RSpec.configure do |config|
  config.color = true
  config.include RSpecHtmlMatchers
end

unless RUBY_ENGINE == 'jruby'
  require 'simplecov'

  formatters = [SimpleCov::Formatter::HTMLFormatter]
  if ENV['CODACY_PROJECT_TOKEN']
    require 'codacy-coverage'
    formatters << Codacy::Formatter
  end

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
  SimpleCov.start do
    add_filter '/spec/'
  end
end
