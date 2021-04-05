local jsonschema = require 'jsonschema'

local schemas = {}

schemas.create = jsonschema.generate_validator {
    type = 'object',
    required = {'key', 'value'},
    properties = {
        key = { type = 'string' },
        value = { type = 'object' },
    },
    additionalProperties = false
}

schemas.update = jsonschema.generate_validator {
  type = 'object',
  required = {'value'},
  properties = {
      value = { type = 'object' },
  },
  additionalProperties = false
}

return schemas
