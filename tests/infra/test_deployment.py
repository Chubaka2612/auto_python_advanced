import socket
import subprocess
import sys

CONTAINER_NAME = "adpyauto-api-1"
REDIS_CONTAINER = "adpyauto-redis-1"

# Docker runs inside WSL on Windows, so prefix commands with "wsl" to reach it
_DOCKER = ["wsl", "docker"] if sys.platform == "win32" else ["docker"]


def test_redis_service_is_running():
    result = subprocess.run(
        [*_DOCKER, "exec", REDIS_CONTAINER, "redis-cli", "ping"],
        capture_output=True,
        text=True,
    )
    assert result.stdout.strip() == "PONG", f"redis-server is not responding: {result.stderr}"


def test_app_container_is_running():
    result = subprocess.run(
        [*_DOCKER, "inspect", "--format", "{{.State.Running}}", CONTAINER_NAME],
        capture_output=True,
        text=True,
    )
    assert result.stdout.strip() == "true", f"Container '{CONTAINER_NAME}' is not running"


def test_app_port_is_reachable():
    try:
        with socket.create_connection(("localhost", 5000), timeout=5):
            pass
    except (ConnectionRefusedError, TimeoutError) as e:
        assert False, f"REST application port 5000 is not reachable: {e}"