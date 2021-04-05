local log = require('log')
local json = require('json')

local http_code = require('http_code')

return function (schema)
    -- Декоратор для валидации входных данных по json schema
    return function(f)
        return function(req, ...)
            
            log.info(string.format('Start validation'))
            if not schema(req:json()) then
                log.info('Invalid data')
                return http_code.bad_request_400
            end
            log.info('Data validation was successful')

            return f(req, ...)
        end
    end
end
