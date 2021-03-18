# frozen_string_literal: true

require_relative 'lib/version'
Gem::Specification.new do |s|
  s.name = 'firebase-stats'
  s.required_ruby_version = '>= 2.4'
  s.version     = FirebaseStats::VERSION
  s.summary     = 'Firebase CSV Stats CLI'
  s.description = 'A CLI tool to get different stats out of the huge Firebase Analytics CSV'
  s.authors     = ['chedabob']
  s.email       = 'matt.malone1@gmail.com'
  s.files = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  s.bindir = 'bin'
  s.executables = 'firebase-stats'
  s.require_paths = Dir['lib']
  s.homepage = 'https://github.com/chedabob/firebase-stats'
  s.license = 'MIT'
  s.add_dependency 'android-devices', '~> 1.0'
  s.add_dependency 'commander', '~> 4.5'
  s.add_dependency 'table_print', '~> 1.5'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'rubocop', '~> 1.10'
end
