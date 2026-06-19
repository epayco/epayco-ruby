require 'json'

module Epayco
  module Pipeline
    # Carga, cachea y resuelve los esquemas JSON de respuesta.
    #
    # Convención: el nombre de un esquema es "recurso.accion" (ej. "customers.get")
    # y vive en lib/epayco/schemas/<nombre>.json. Los fragmentos reutilizables
    # viven bajo "fragments/<nombre>" (ej. "fragments/customer").
    #
    # Los esquemas se parsean con claves String (para preservar las directivas
    # "$ref", "$each", etc.) y se cachean congelados tras la primera lectura.
    module SchemaRegistry
      DEFAULT_DIR = File.expand_path('../schemas', __dir__)

      class << self
        # Devuelve el esquema parseado (Hash con claves String) o nil si el
        # archivo no existe. Que devuelva nil es intencional: habilita el
        # passthrough cuando un endpoint aún no tiene esquema.
        def fetch(schema_name)
          return cache[schema_name] if cache.key?(schema_name)
          cache[schema_name] = load_file("#{schema_name}.json")
        end

        # Igual que fetch, pero un fragmento referenciado que no existe es un
        # error de configuración, no un passthrough.
        def fetch_fragment(ref)
          fetch(ref) || raise(Epayco::Error.new('103', Epayco.lang))
        end

        # Directorio de esquemas. Sobrescribible en tests.
        def dir
          @dir || DEFAULT_DIR
        end

        def dir=(path)
          @dir = path
          @cache = {}
        end

        # Limpia la caché (tests).
        def reset!
          @dir = nil
          @cache = {}
        end

        private

        def cache
          @cache ||= {}
        end

        def load_file(filename)
          path = File.join(dir, filename)
          return nil unless File.exist?(path)
          JSON.parse(File.read(path)).freeze
        rescue JSON::ParserError
          raise Epayco::Error.new('103', Epayco.lang) # formato de esquema inválido
        end
      end
    end
  end
end
