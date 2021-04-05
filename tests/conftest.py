import os

import pytest
import tarantool


@pytest.fixture
def db():
    conn = tarantool.connect(
        "tarantool_test",
        3301,
        user=os.environ['TARANTOOL_USER_NAME'],
        password=os.environ['TARANTOOL_USER_PASSWORD']
    )
    yield conn
    conn.eval('box.space.app:truncate()')
    conn.eval('box.space.time:truncate()')
