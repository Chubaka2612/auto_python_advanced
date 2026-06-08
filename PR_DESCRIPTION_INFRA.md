# Add Infrastructure Tests with pytest-testinfra

Implemented deployment verification tests using pytest-testinfra that confirm the application stack is up and healthy after `docker compose up`.

---

## What's included

- `tests/infra/__init__.py` — marks the directory as a Python package
- `tests/infra/conftest.py` — empty, reserved for future fixtures
- `tests/infra/test_deployment.py` — 3 infrastructure test cases

---

## How to run

**Prerequisites — build and start the stack:**
```bash
docker compose build
docker compose up -d
```

**Run infra tests (Windows PowerShell):**
```bash
python -m pytest tests/infra/ -v
```

**Run infra tests only, skip API tests:**
```bash
python -m pytest tests/infra/ -v
```

**Run the full test suite:**
```bash
python -m pytest tests/ -v
```

---

## Test cases

### test_redis_service_is_running
Verifies that the Redis server is up and accepting connections by running `redis-cli ping` inside the Redis container. A healthy Redis instance responds with `PONG`.

**Equivalent CLI command:**
```bash
# Windows (WSL)
wsl docker exec adpyauto-redis-1 redis-cli ping

# Linux / Mac
docker exec adpyauto-redis-1 redis-cli ping
```
Expected output: `PONG`

---

### test_app_container_is_running
Verifies that the REST API Docker container exists and is in a running state by inspecting its metadata.

**Equivalent CLI command:**
```bash
# Windows (WSL)
wsl docker inspect --format "{{.State.Running}}" adpyauto-api-1

# Linux / Mac
docker inspect --format "{{.State.Running}}" adpyauto-api-1
```
Expected output: `true`

---

### test_app_port_is_reachable
Verifies that the REST application is reachable by opening a TCP connection to port 5000.

**Equivalent CLI command:**
```bash
# Linux / Mac / WSL
nc -zv localhost 5000

# Windows PowerShell
Test-NetConnection -ComputerName localhost -Port 5000
```
Expected output: `Connection to localhost 5000 port [tcp/*] succeeded!`

---

## Notes

- Tests use `wsl docker` on Windows and plain `docker` on Linux/Mac — handled automatically via `sys.platform` check
- Container names (`adpyauto-api-1`, `adpyauto-redis-1`) are set by docker-compose based on the project directory name — update the constants in `test_deployment.py` if your directory name differs
- testinfra's `local://` and `docker://` backends are not compatible with Windows Python 3.12 (bytes encoding issue in subprocess), so tests use Python's `subprocess` and `socket` modules directly
