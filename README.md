# tarantool test

## Проект доступен по http://tarantool.c-studio.space
## Описание API

* GET `/kv/:key` - получить значение по ключу
```bash
curl http://tarantool.c-studio.space/kv/test
```
* POST `/kv` - Создать запись по ключу
```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"key":"test","value":{"test_key":"test_value"}}' \
  http://tarantool.c-studio.space/kv
```
* PUT `/kv/:key` - Обновить запись по ключу
```bash
curl --header "Content-Type: application/json" \
  --request PUT \
  --data '{"value":{"new_test_key":"new_test_value"}}' \
  http://tarantool.c-studio.space/kv
```

* DELETE `/kv/:key` - Удалить запись по ключу
```bash
curl --request DELETE http://tarantool.c-studio.space/kv/test
```


## Запуск проекта на локальной машине

* Добавить в /etc/hosts  127.0.0.1 tarantool.localhost.com
* Добавить nginx конфиг
```sh
cd /etc/nginx/sites-enabled
sudo ln -s [путь_до_проекта]/nginx.cfg tarantool.cfg

sudo nginx -t
sudo nginx -s reload
```

* Собрать images по схеме описанной в docker-compose.yml
```sh
make build
```
* Запустить проект
```sh
make start
```

* Проект будет доступен по адресу: http://tarantool.localhost.com

* Остановить все запущенные контейнеры
```sh
make stop
```

* Список доступных команд 
```sh
make help
```
