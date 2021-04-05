local json = require('json')

local http_code = {}


--200
http_code.created_201 = {
    status = 201,
}

http_code.accepted_202 = {
    status = 202,
}

--400
http_code.bad_request_400 = {
    status = 400,
    body = 'Ошибка валидации'
}

http_code.not_found_404 = {
    status = 404,
    body = 'Не найдено'
}

http_code.conflict_409 = {
    status = 409,
    body = 'Объект уже существует'
}

http_code.too_many_request_429 = {
    status = 429,
    body = 'Большое кол-во запросов'
}

return http_code
