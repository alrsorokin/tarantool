local log = require('log')

local http_code = require('http_code')

local middlewares = {}


middlewares.too_many_request_handler = function(req)
    log.info('test')
    log.info(req:headers())
    local ip = req:header('x-real-ip')

    local record = box.space.time:get(ip)
    local current_time = os.time(os.date("!*t"))
    if record and current_time-record[2] < tonumber(os.getenv("REQUEST_TIMEOUT")) then
        
        return http_code.too_many_request_429
    end

    box.space.time:replace{ip, current_time}
    return req:next()
end

return middlewares
