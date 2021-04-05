local log = require('log')

local http_code = require('http_code')

-- Декоратор получения данных по ключу из url с помощью фабрики
return function (factory)
    return function(f)
        return function(req, ...)
            local key = req:stash('key')

            log.info(string.format('Start data retrieval by key: "%s"', key))
            local context = factory(key)
            if not context then
                log.info(string.format('Key "%s" not found', key))
                return http_code.not_found_404
            end
            log.info('Data found successfully')

            req.context = context
            return f(req, ...)
        end
    end
end

