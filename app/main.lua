package.path = '/opt/tarantool/routes/?.lua;/opt/tarantool/lib/?.lua;'..package.path;

box.cfg {listen = 3301}


box.once("init", function()
    -- space для хранения данных от пользователя
    box.schema.space.create('app')
    box.space.app:format({
        {name='key', type='string'},
        {name='value', type='map'}
    })
    box.space.app:create_index('primary', {parts={'key'}})

    -- space для хранения последнего времени запроса от пользователя
    box.schema.space.create('time')
    box.space.time:format({
        {name='host', type='string'},
        {name='timestamp', type='number'}
    })
    box.space.time:create_index('primary', {parts={'host'}})

    box.schema.user.passwd('admin', os.getenv("TARANTOOL_USER_PASSWORD"))
end)

local server = require('http.server').new(nil, 8080)
local router = require('http.router').new({charset='application/json'})
server:set_router(router)

local crud = require('crud')
local middlewares = require('middlewares')

-- Подключение мидлов
router:use(middlewares.too_many_request_handler, {
    path = '/.*',
    method='ANY'
})

-- Подключение роутов
router:route({ path = '/kv', method = 'POST' }, crud.post)
router:route({ path = '/kv/:key', method = 'GET' }, crud.get)
router:route({ path = '/kv/:key', method = 'PUT' }, crud.put)
router:route({ path = '/kv/:key', method = 'DELETE' }, crud.delete)

server:start()
