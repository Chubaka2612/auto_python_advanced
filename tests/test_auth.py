# Auth tests
import pytest
import requests

from utils.config import get_credentials

LOGIN_URL = "/api/v1/login"


@pytest.mark.test_id("TC02")
def test_post_login_valid_credentials(hostname):
    response = requests.post(
        f"{hostname}{LOGIN_URL}",
        json=get_credentials(),
    )
    assert response.status_code == 200
    body = response.json()
    assert "access_token" in body
    assert body["access_token"] is not None


@pytest.mark.test_id("TC03")
def test_post_login_invalid_password(hostname):
    response = requests.post(
        f"{hostname}{LOGIN_URL}",
        json={"username": "test", "password": "wrongpassword"},
    )
    assert response.status_code == 401
    assert response.json()["message"] == "No such username or password"


@pytest.mark.test_id("TC04")
def test_post_login_missing_required_fields(hostname):
    response = requests.post(
        f"{hostname}{LOGIN_URL}",
        json={"username": "test"},
    )
    assert response.status_code == 400
    assert response.json()["message"] == "Bad request body"


@pytest.mark.test_id("TC05")
def test_post_login_wrong_content_type(hostname):
    response = requests.post(
        f"{hostname}{LOGIN_URL}",
        data="username=test&password=test",
        headers={"Content-Type": "text/plain"},
    )
    assert response.status_code == 415
    assert response.json()["message"] == "Content-type must be application/json"
