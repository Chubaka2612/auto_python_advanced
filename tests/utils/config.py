import json
from pathlib import Path

_CONFIG_PATH = Path(__file__).parent.parent / "config" / "test_config.json"


def get_credentials() -> dict:
    return json.loads(_CONFIG_PATH.read_text())["credentials"]
