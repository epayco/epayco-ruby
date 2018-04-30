# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = "epayco-ruby"
  s.version           = "0.0.6"
  s.summary           = "Ruby wrapper for Epayco API"
  s.description       = "API to interact with Epayco\nhttps://epayco.co"
  s.authors           = ["Epayco development team", "Jonathan Aguirre"]
  s.email             = ["jaguirre@payco.co"]
  s.homepage          = "https://epayco.co/"
  s.files             = []

  s.license           = "MIT"
  s.executables.push("epayco")
  s.add_dependency('rest-client', '~> 2.0')
  s.add_dependency('json', '~> 2.1')
  s.add_development_dependency('cutest', '~> 1.2')
  s.add_development_dependency('mocha', '~> 1.1')

  s.files = %w{
    bin/epayco
    lib/epayco.rb
    lib/keylang.json
    lib/epayco-ruby.rb
    lib/epayco/resources.rb
    lib/epayco/operations.rb
  }

  s.test_files = %w{
    tests/testing.rb
    tests/test_helper.rb
  }
end
