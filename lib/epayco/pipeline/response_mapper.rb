module Epayco
  module Pipeline
    # Aplica un esquema declarativo a la respuesta cruda y produce el contrato
    # de salida estable.
    #
    # Cada hoja del esquema es un path "dot-notation" o una directiva:
    #   "data.id_customer"                       -> dig del path
    #   { "$const": valor }                      -> valor literal
    #   { "$ref": "fragments/customer",          -> inserta un fragmento sobre
    #     "$from": "data" }                         el sub-nodo indicado por $from
    #   { "$each": <ref u objeto>, "$from": "x" } -> mapea cada elemento del array
    #   { "$path": "insert", "$format": "date" } -> dig del path + transformación
    #   { "$coalesce": ["_id", "id_customer"] }  -> primer candidato no nil
    #   { ...objeto... }                         -> sub-objeto anidado
    #
    # Las claves del esquema que empiezan por "_" (ej. "_meta") se ignoran.
    # Las claves de salida se emiten como símbolos, consistente con el formato
    # legacy (JSON.parse symbolize_names: true).
    module ResponseMapper
      class << self
        def apply(raw, schema)
          return raw unless raw.is_a?(Hash) && schema.is_a?(Hash)
          build(raw, schema)
        end

        private

        def build(source, node)
          node.each_with_object({}) do |(key, spec), acc|
            next if key.to_s.start_with?('_')
            acc[key.to_sym] = resolve(source, spec)
          end
        end

        def resolve(source, spec)
          case spec
          when String then dig_path(source, spec)
          when Hash   then resolve_directive(source, spec)
          else spec
          end
        end

        def resolve_directive(source, spec)
          if spec.key?('$const')
            spec['$const']
          elsif spec.key?('$each')
            map_each(source, spec)
          elsif spec.key?('$ref')
            map_ref(source, spec)
          elsif spec.key?('$path')
            map_path(source, spec)
          elsif spec.key?('$coalesce')
            map_coalesce(source, spec)
          else
            build(source, spec) # objeto anidado plano
          end
        end

        # { "$coalesce": ["_id", "id_customer", { "$path": "x", "$format": "date" }] }
        # Devuelve el primer candidato que resuelva a un valor no nil. Cada
        # candidato puede ser un path (String) o una directiva (Hash). Permite
        # un mismo contrato sobre endpoints que nombran los campos distinto.
        def map_coalesce(source, spec)
          candidates = spec['$coalesce']
          return nil unless candidates.is_a?(Array)
          candidates.each do |candidate|
            value = resolve(source, candidate)
            return value unless value.nil?
          end
          nil
        end

        # { "$path": "insert", "$format": "date" }
        # Lee el path y, si hay $format, aplica el transformador con ese nombre.
        def map_path(source, spec)
          value = dig_path(source, spec['$path'])
          spec.key?('$format') ? Formatters.apply(spec['$format'], value) : value
        end

        # { "$each": <ref u objeto>, "$from": "data" }
        def map_each(source, spec)
          arr = spec.key?('$from') ? dig_path(source, spec['$from']) : source
          return [] unless arr.is_a?(Array)
          item_schema = expand(spec['$each'])
          arr.map { |item| item.is_a?(Hash) ? build(item, item_schema) : item }
        end

        # { "$ref": "fragments/x", "$from": "data" }
        def map_ref(source, spec)
          sub = spec.key?('$from') ? dig_path(source, spec['$from']) : source
          return nil unless sub.is_a?(Hash)
          build(sub, SchemaRegistry.fetch_fragment(spec['$ref']))
        end

        # Resuelve un { "$ref": "..." } a su esquema; deja pasar un objeto literal.
        def expand(spec)
          if spec.is_a?(Hash) && spec.key?('$ref')
            SchemaRegistry.fetch_fragment(spec['$ref'])
          else
            spec
          end
        end

        # Navega "data.id_customer" tolerando claves símbolo o string.
        def dig_path(source, path)
          path.to_s.split('.').reduce(source) do |node, k|
            next nil unless node.is_a?(Hash)
            node.key?(k.to_sym) ? node[k.to_sym] : node[k]
          end
        end
      end
    end
  end
end
