local log = require('log')

local http_code = require('http_code')

local middlewares = {}


middlewares.too_many_request_handler = function(req)
    log.info('test')
    log.info(req:headers())
    local host = req:header('host')

    local record = box.space.time:get(host)
    local current_time = os.time(os.date("!*t"))
    if record and current_time-record[2] < tonumber(os.getenv("REQUEST_TIMEOUT")) then
        
        return http_code.too_many_request_429
    end

    box.space.time:replace{host, current_time}
    return req:next()
end

return middlewares
