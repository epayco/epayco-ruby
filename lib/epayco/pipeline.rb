require_relative 'pipeline/schema_registry'
require_relative 'pipeline/formatters'
require_relative 'pipeline/response_normalizer'
require_relative 'pipeline/response_mapper'

module Epayco
  # Orquesta la transformación de una respuesta cruda en el contrato estable,
  # según el esquema "recurso.accion".
  #
  # Solo se invoca en modo :mapped (ver Epayco.mapped?). Si el endpoint todavía
  # no tiene esquema, devuelve la respuesta cruda sin tocar (passthrough), de
  # modo que la migración pueda ser endpoint por endpoint.
  module Pipeline
    def self.run(raw, schema_name)
      schema = SchemaRegistry.fetch(schema_name)
      return raw if schema.nil? # passthrough: endpoint aún sin esquema

      normalized = ResponseNormalizer.call(raw)

      # Respuestas de error no se fuerzan por el esquema de éxito (perderían el
      # mensaje real). Si existe un esquema de error "<recurso>.<accion>.error"
      # se aplica; si no, se devuelve el error real de la respuesta tal cual.
      if error?(normalized)
        error_schema = SchemaRegistry.fetch("#{schema_name}.error")
        return error_schema ? ResponseMapper.apply(normalized, error_schema) : normalized
      end

      ResponseMapper.apply(normalized, schema)
    end

    # Un cuerpo es de error si el backend marca success/status en false.
    def self.error?(body)
      return false unless body.is_a?(Hash)
      [:success, :status].any? { |k| body[k] == false || body[k.to_s] == false }
    end
  end
end
