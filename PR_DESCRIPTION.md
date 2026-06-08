# Add pytest Test Automation Framework

Implemented a small TAF on top of the existing Flask + Redis API using pytest.
Covers auth, test suite, and test case endpoints with fixtures, hooks, and parallel execution.

---

## What's included

- `tests/core/endpoint.py` — `Endpoint` class with CRUD methods and `/` path chaining
- `tests/utils/logger.py` — shared logger factory
- `tests/utils/config.py` — reads credentials from `tests/config/test_config.json`
- `tests/conftest.py` — `hostname`, `bearer_token`, and endpoint fixtures
- `tests/test_auth.py` — 4 login tests (TC02–TC05)
- `tests/test_test_suites.py` — 5 test suite tests (TC06, TC09–TC12)
- `tests/test_test_cases.py` — 8 test case tests (TC16–TC17, TC19–TC23, TC26)
- `tests/report/` — HTML and XML reports attached

---

## How to run

**Prerequisites — start Redis and the API server:**
```bash
# terminal 1
docker run -p 6379:6379 redis:7-alpine

# terminal 2
python -m rest
```

**Install dependencies:**
```bash
pip install pytest pytest-xdist pytest-html requests
```

**Run all tests in parallel with reports:**
```bash
python -m pytest tests/ -n auto --dist=loadgroup --html=tests/report/report.html --self-contained-html --junit-xml=tests/report/report.xml -v
```

**Run a specific file:**
```bash
python -m pytest tests/test_auth.py -v
```

**Run against a different host:**
```bash
python -m pytest tests/ -v --host=http://your-host:5000
```

**Results:** open `tests/report/report.html` in a browser.

---

## Notes

- Suite and case tests are grouped with `xdist_group("data")` so they run sequentially on one worker — this avoids ID collisions caused by the server's counter-based ID generation
- Credentials are stored in `tests/config/test_config.json` — update there if they change
