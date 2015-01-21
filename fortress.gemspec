# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fortress/version'

Gem::Specification.new do |spec|
  spec.name          = 'fortress'
  spec.version       = Fortress::VERSION
  spec.authors       = ['Guillaume Hain']
  spec.email         = ['zedtux@zedroot.org']
  spec.summary       = 'Secure your Rails application from preventing access ' \
                       'to everything to opening allowed actions.'
  spec.description   = 'The rigths management libraries available today are ' \
                       'all based on the principle: everything is open and ' \
                       'you close it explicitely. Fortress is immediately ' \
                       'closing access to every actions of every controllers' \
                       ' when you install it. It\'s then up to you to open ' \
                       'the allowed actions.'
  spec.homepage      = 'https://github.com/YourCursus/fortress'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '> 3.1'
  spec.add_dependency 'activesupport', '> 3.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
