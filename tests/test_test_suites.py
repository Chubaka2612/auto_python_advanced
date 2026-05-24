# Test suite CRUD tests
import pytest

SUITE_TITLE = "API Test Suite"


@pytest.fixture
def created_suite(test_suites_endpoint):
    response = test_suites_endpoint.post({"title": SUITE_TITLE})
    assert response.status_code == 200, f"Suite creation failed: {response.text}"
    suite_id = response.json()["id"]
    yield suite_id
    test_suites_endpoint.delete(suite_id)


@pytest.mark.test_id("TC06")
def test_post_test_suite_create(test_suites_endpoint):
    response = test_suites_endpoint.post({"title": SUITE_TITLE})
    assert response.status_code == 200
    body = response.json()
    assert "id" in body
    assert body["message"] == "Test suite successfully added"
    test_suites_endpoint.delete(body["id"])


@pytest.mark.test_id("TC09")
@pytest.mark.usefixtures("created_suite")
def test_get_all_test_suites(test_suites_endpoint):
    response = test_suites_endpoint.get()
    assert response.status_code == 200
    body = response.json()
    assert "test_suites" in body
    assert isinstance(body["test_suites"], list)
    assert len(body["test_suites"]) >= 1


@pytest.mark.test_id("TC10")
def test_get_test_suite_by_id(test_suites_endpoint, created_suite):
    response = test_suites_endpoint.get(created_suite)
    assert response.status_code == 200
    body = response.json()
    assert "test_suite" in body
    suite = body["test_suite"]
    assert suite["id"] == created_suite
    assert "title" in suite
    assert "cases" in suite


@pytest.mark.test_id("TC11")
def test_get_test_suite_non_existent_id(test_suites_endpoint):
    response = test_suites_endpoint.get("999999")
    assert response.status_code == 404
    assert "doesn't exist" in response.json()["message"]


@pytest.mark.test_id("TC12")
def test_put_test_suite_update(test_suites_endpoint, created_suite):
    response = test_suites_endpoint.put(created_suite, {"title": "Updated Suite"})
    assert response.status_code == 200
    assert response.json()["message"] == "Test suite successfully updated"
