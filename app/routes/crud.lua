local log = require('log')

local context = require('context')
local http_code = require('http_code')
local validate = require('validator')

local factory = require('factory')
local schemas = require('schemas')


local crud = {}

crud.get = context(factory)(function (req)
    log.info('Return data')
    return req:render { json = req.context[2]}
end)

crud.post = validate(schemas.create)(function (req)
    local json_data = req:json()
    if factory(json_data['key']) then
        log.info(string.format('Key "%s" is exist', json_data['key']))
        return http_code.conflict_409
    end

    box.space.app:insert{json_data['key'],json_data['value']}

    log.info(string.format('Key "%s" added successfully', json_data['key']))
    return http_code.created_201
end)

crud.put = validate(schemas.update)(context(factory)(function(req)
    box.space.app:replace{req.context[1], req:json()['value']}

    log.info(string.format('Key "%s" updated successfully', req.context[1]))
    return http_code.accepted_202
end))

crud.delete = context(factory)(function(req)
    box.space.app:delete(req.context[1])

    log.info(string.format('Key "%s" has been deleted', req.context[1]))
    return http_code.accepted_202
end)


return crud
