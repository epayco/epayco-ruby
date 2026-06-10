# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/)
y el proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [2.0.0] - 2026-06-10

### Añadido
- **Pipeline de formato de respuesta** (`lib/epayco/pipeline/`): convierte la
  respuesta cruda del backend en un contrato estable e independiente del
  endpoint, definido de forma declarativa por esquemas JSON.
  - `SchemaRegistry`: carga, cachea (`freeze`) y resuelve esquemas por nombre
    `"recurso.accion"` y fragmentos reutilizables (`fragments/...`).
  - `ResponseNormalizer`: garantiza un Hash con claves símbolo a partir de la
    respuesta (Hash, `RestClient::Response` o String).
  - `ResponseMapper`: aplica el esquema con las directivas `$const`, `$ref`,
    `$each`, `$path`, `$format` y `$coalesce`.
  - `Formatters`: transformadores de valor con nombre (`date` → `dd/mm/aaaa`,
    `datetime` → `dd/mm/aaaa HH:MM:SS`).
- **Configuración `Epayco.response_format`** con helpers `Epayco.mapped?` /
  `Epayco.legacy?`.
- **Directiva `$coalesce`**: toma el primer origen no nulo de una lista, lo que
  permite un mismo contrato sobre endpoints que nombran los campos distinto
  (p. ej. `id_customer` desde `_id` o `id_customer`; fecha desde `created`,
  `createdAt` o `insert`).
- **Manejo de errores reales**: las respuestas de error (`success`/`status` en
  `false`) ya no se fuerzan por el esquema de éxito; se devuelve el error real
  del backend, o se mapea con un esquema opcional `"<recurso>.<accion>.error"`.
- **Esquema `customers.get`** (+ fragmentos `customer` y `card`) verificado
  contra los endpoints `/api/v1/customer/{uid}` y
  `/payment/v1/customer/{key}/{uid}`.

### Cambiado
- **(BREAKING)** El formato de salida por defecto pasa de crudo a **mapeado**
  (`:mapped`). Para conservar el comportamiento de la serie 1.x, fijar
  explícitamente `Epayco.response_format = :legacy`.
- Cada operación enruta su salida por `Resource.deliver`, que aplica el pipeline
  en modo `:mapped` (o passthrough crudo si el endpoint aún no tiene esquema) y
  mantiene la respuesta cruda en modo `:legacy`. Firmas y URLs sin cambios.
- Versión del gem: `1.7.0` → `2.0.0`.
