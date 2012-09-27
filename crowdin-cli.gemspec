# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','crowdin-cli','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'crowdin-cli'
  s.version = Crowdin::CLI::VERSION
  s.author = 'Anton Maminov'
  s.email = 'anton.linux@gmail.com'
  s.homepage = 'https://github.com/mamantoha/crowdin-cli'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  # Add your other files here if you make them
  s.files = %w(
    bin/crowdin-cli
    lib/crowdin-cli/version.rb
    lib/crowdin-cli.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','crowdin-cli.rdoc']
  s.rdoc_options << '--title' << 'crowdin-cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'crowdin-cli'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli', '2.1.0')
  s.add_runtime_dependency('rubyzip', '0.9.9')
  s.add_runtime_dependency('crowdin-api', '0.0.3')
end
