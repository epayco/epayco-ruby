require 'json'

module Epayco
  module Pipeline
    # Garantiza que la respuesta cruda sea un Hash con claves símbolo (el body
    # del backend), independientemente de si Epayco.request devolvió un Hash ya
    # parseado (éxito) o un objeto RestClient::Response / String (rama de error).
    #
    # No reescribe el contenido: solo asegura el tipo para que el Mapper pueda
    # navegar por paths de forma uniforme. La forma final (envelope, claves
    # estables) la decide el esquema en el Mapper.
    module ResponseNormalizer
      class << self
        def call(raw)
          return raw if raw.is_a?(Hash)

          body = extract_body(raw)
          return body if body.is_a?(Hash)

          # No se pudo interpretar como JSON: se envuelve de forma mínima para
          # no perder la información original.
          { success: false, data: nil, error: { message: raw.to_s } }
        end

        private

        # Extrae y parsea el body de un RestClient::Response o de un String.
        def extract_body(raw)
          str = raw.respond_to?(:body) ? raw.body : raw
          JSON.parse(str.to_s, symbolize_names: true)
        rescue JSON::ParserError, TypeError
          nil
        end
      end
    end
  end
end
