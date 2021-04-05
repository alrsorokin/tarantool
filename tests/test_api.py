import json

import requests


def test_success_get_key(db):
    ''' Тест успешного получения ключа
    '''
    db.insert('app', ('test', {'key': 'value'}))
    response = requests.get('http://tarantool_test:8080/kv/test')
    assert response.status_code == 200, (
        'Неверный код ответа сервера: %s' % response.status_code
    )
    assert response.json() == {'key': 'value'}, (
        'Неверное тело ответа'
    )


def test_failure_get_key(db):
    ''' Тест неудачной попытки получения ключа
    '''
    response = requests.get('http://tarantool_test:8080/kv/test')
    assert response.status_code == 404, (
        'Неверный код ответа сервера: %s' % response.status_code
    )


def test_success_create_key(db):
    ''' Тест успешного создания ключа
    '''
    response = requests.post(
        'http://tarantool_test:8080/kv',
        data=json.dumps({'key': 'test', 'value': {'test_key': 'test_value'}})
    )
    assert response.status_code == 201, (
        'Неверный код ответа сервера: %s' % response.status_code
    )

    data = db.space('app').select('test')
    assert data[0][1] == {'test_key': 'test_value'}, 'Неверно сохарнилось значение'


def test_failure_validation_error_create_key(db):
    ''' Тест неудачной попытки создания ключа с невалидным json
    '''
    response = requests.post(
        'http://tarantool_test:8080/kv',
        data=json.dumps({'key': 'test', 'value': 'test'})
    )
    assert response.status_code == 400, (
        'Неверный код ответа сервера: %s' % response.status_code
    )


def test_failure_double_key_create_key(db):
    ''' Тест неудачной попытки создания ключа с дублирование существующего
    '''
    db.insert('app', ('test', {'key': 'value'}))
    response = requests.post(
        'http://tarantool_test:8080/kv',
        data=json.dumps({'key': 'test', 'value': {'test_key': 'test_value'}})
    )
    assert response.status_code == 409, (
        'Неверный код ответа сервера: %s' % response.status_code
    )


def test_success_update_key(db):
    ''' Тест успешного обновления ключа
    '''
    db.insert('app', ('test', {'key': 'value'}))
    response = requests.put(
        'http://tarantool_test:8080/kv/test',
        data=json.dumps({'value': {'test_key': 'test_value'}})
    )
    assert response.status_code == 202, (
        'Неверный код ответа сервера: %s' % response.status_code
    )
    data = db.space('app').select('test')
    assert data[0][1] == {'test_key': 'test_value'}, 'Неверно сохарнилось значение'


def test_success_delete_key(db):
    ''' Тест успешного удаления ключа
    '''
    db.insert('app', ('test', {'key': 'value'}))
    response = requests.delete('http://tarantool_test:8080/kv/test')
    assert response.status_code == 202, (
        'Неверный код ответа сервера: %s' % response.status_code
    )
    data = db.space('app').select('test')
    assert not data, 'Запись не была удалена'
