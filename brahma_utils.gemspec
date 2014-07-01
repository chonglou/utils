# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brahma_utils/version'

Gem::Specification.new do |spec|
  spec.name          = 'brahma_utils'
  spec.version       = BrahmaUtils::VERSION
  spec.authors       = ['Jitang Zheng']
  spec.email         = ['jitang.zheng@gmail.com']
  spec.summary       = 'Brahma项目工具类'
  spec.description   = '辅助类'
  spec.homepage      = 'https://github.com/chonglou/utils'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'highline'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'redcarpet'
  spec.add_dependency 'mysql2'
  spec.add_dependency 'sequel'
  spec.add_dependency 'redis'
  spec.add_dependency 'bunny'
  spec.add_dependency 'iconv'
  spec.add_dependency 'connection_pool'
end
