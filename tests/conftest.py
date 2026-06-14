# Fixtures and hooks
import pytest
import requests
from core.endpoint import Endpoint
from utils.config import get_credentials


def pytest_addoption(parser):
    parser.addoption("--host", default="http://localhost:5000", help="Base URL of the server under test")


@pytest.fixture(scope="session")
def hostname(request) -> str:
    return request.config.getoption("--host")


@pytest.fixture(scope="session")
def login_url(hostname) -> str:
    return f"{hostname}/api/v1/login"


@pytest.fixture(scope="session")
def bearer_token(login_url) -> str:
    credentials = get_credentials()

    response = requests.post(
        login_url,
        json=credentials,
    )

    assert response.status_code == 200, f"Lohin failed: {response.text}"
    json = response.json()
    assert "access_token" in json, f"access_token missing from login response: {json}"
    return json["access_token"]


@pytest.fixture(scope="session")
def api_endpoint(hostname, bearer_token) -> Endpoint:
    return Endpoint(hostname, bearer_token) / "api/v1"


@pytest.fixture(scope="session")
def test_suites_endpoint(api_endpoint) -> Endpoint:
    return api_endpoint / "test_suites"


@pytest.fixture(scope="session")
def test_cases_endpoint(api_endpoint) -> Endpoint:
    return api_endpoint / "test_cases"
