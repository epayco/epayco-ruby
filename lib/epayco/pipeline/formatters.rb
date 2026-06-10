require 'date'

module Epayco
  module Pipeline
    # Transformadores de valores con nombre, usados por la directiva $format
    # del esquema. Ej:  { "$path": "insert", "$format": "date" }
    #
    # Reglas:
    # - nil se devuelve sin tocar.
    # - Un formato desconocido devuelve el valor original (no rompe).
    # - Un valor que no se puede interpretar como fecha devuelve el original.
    module Formatters
      def self.apply(name, value)
        return value if value.nil?
        fn = REGISTRY[name.to_s]
        fn ? fn.call(value) : value
      end

      # Interpreta una fecha ISO-8601 (2026-02-06T20:24:55.000Z) o similar.
      def self.parse_date(value)
        DateTime.parse(value.to_s)
      rescue ArgumentError, TypeError
        nil
      end

      REGISTRY = {
        # 2026-02-06T20:24:55.000Z -> 06/02/2026
        "date" => ->(v) { (d = parse_date(v)) ? d.strftime("%d/%m/%Y") : v },
        # 2026-02-06T20:24:55.000Z -> 06/02/2026 20:24:55
        "datetime" => ->(v) { (d = parse_date(v)) ? d.strftime("%d/%m/%Y %H:%M:%S") : v }
      }.freeze
    end
  end
end
