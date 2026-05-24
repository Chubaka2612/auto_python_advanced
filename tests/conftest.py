# Fixtures and hooks
import pytest
import requests

from utils.config import get_credentials
from core.endpoint import Endpoint


def pytest_addoption(parser):
    parser.addoption("--host", default="http://localhost:5000", help="Base URL of the server under test")


@pytest.fixture(scope="session")
def hostname(request) -> str:
    return request.config.getoption("--host")


@pytest.fixture(scope="session")
def bearer_token(hostname) -> str:
    credentials = get_credentials()

    response = requests.post(
        f"{hostname}/api/v1/login",
        json=credentials,
    )

    assert response.status_code == 200, f"Login failed: {response.text}"
    return response.json()["access_token"]


@pytest.fixture(scope="session")
def test_suites_endpoint(hostname, bearer_token) -> Endpoint:
    return Endpoint(hostname, bearer_token) / "api/v1/test_suites"


@pytest.fixture(scope="session")
def test_cases_endpoint(hostname, bearer_token) -> Endpoint:
    return Endpoint(hostname, bearer_token) / "api/v1/test_cases"
