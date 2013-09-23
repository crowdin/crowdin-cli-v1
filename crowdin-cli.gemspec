# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','crowdin-cli','version.rb'])

Gem::Specification.new do |gem|
  gem.name = 'crowdin-cli'
  gem.version = Crowdin::CLI::VERSION

  gem.summary = 'Crowdin CLI.'
  gem.description = 'A command-line interface to sync files between your computer/server and Crowdin.'
  gem.author = ['Crowdin']
  gem.email = ['support@crowdin.net']
  gem.homepage = 'https://github.com/crowdin/crowdin-cli/'
  gem.license = 'LICENSE'

  gem.files = %w(
    bin/crowdin-cli
    lib/crowdin-cli/version.rb
    lib/crowdin-cli.rb
    locales/en.yml
    README.md
    LICENSE
  )
  gem.require_paths << 'lib'
  gem.bindir = 'bin'
  gem.executables << 'crowdin-cli'
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_runtime_dependency('gli', '>= 2.7.0')
  gem.add_runtime_dependency('rubyzip', '>= 1.0.0')
  gem.add_runtime_dependency('crowdin-api', '>= 0.2.0')
  gem.add_runtime_dependency('i18n', '>= 0.6.4')
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.3'
end
