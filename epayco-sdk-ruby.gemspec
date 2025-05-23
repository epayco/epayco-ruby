# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = "epayco-sdk-ruby"
  s.version           = "1.6.0"
  s.summary           = "Ruby wrapper for Epayco API"
  s.description       = "API to interact with Epayco\nhttps://epayco.co"
  s.authors           = ["Epayco development team", "Ricardo Saldarriaga", "Gerson Vasquez"]
  s.email             = ["ricardo.saldarriaga@payco.co", "gerson.vasquez@epayco.com"]
  s.homepage          = "https://epayco.co/"
  s.files             = []

  s.license           = "MIT"
  s.executables.push("epayco")
  s.add_dependency('rest-client', '~> 2.1')
  s.add_dependency('json', '~> 2.7')
  s.add_dependency('dotenv', '~> 2.8')
  s.add_development_dependency('cutest', '~> 1.2')
  s.add_development_dependency('mocha', '~> 2.7')

  s.files = %w{
    bin/epayco
    lib/epayco.rb
    lib/keylang.json
    lib/keylang_apify.json
    lib/epayco-sdk-ruby.rb
    lib/epayco/resources.rb
    lib/epayco/operations.rb
  }

  s.test_files = %w{
    tests/testing.rb
    tests/test_helper.rb
  }
end
