# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = "epayco-sdk-ruby"
  s.version           = "2.0.0"
  s.summary           = "Ruby wrapper for ePayco API"
  s.description       = "API to interact with ePayco\nhttps://epayco.com"
  s.authors           = ["ePayco development team", "Ricardo Saldarriaga", "Gerson Vasquez"]
  s.email             = ["ricardo.saldarriaga@epayco.com", "gerson.vasquez@epayco.com"]
  s.homepage          = "https://epayco.com/"
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
    lib/epayco/client.rb
    lib/epayco/pipeline.rb
    lib/epayco/pipeline/schema_registry.rb
    lib/epayco/pipeline/formatters.rb
    lib/epayco/pipeline/response_normalizer.rb
    lib/epayco/pipeline/response_mapper.rb
  }

  # Esquemas de respuesta (formato :mapped). Se incluyen por glob para que los
  # nuevos esquemas queden empaquetados sin editar el gemspec cada vez.
  s.files += Dir["lib/epayco/schemas/**/*.json"]

  s.test_files = %w{
    tests/testing.rb
    tests/test_helper.rb
  }
end
