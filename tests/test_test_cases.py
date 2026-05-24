# Test case CRUD tests
import pytest

SUITE_TITLE = "Test Suite for Cases"
CASE_TITLE = "Login Functionality Test"
CASE_DESCRIPTION = "Tests the POST /login endpoint"


@pytest.fixture
def created_suite(test_suites_endpoint):
    response = test_suites_endpoint.post({"title": SUITE_TITLE})
    assert response.status_code == 200, f"Suite creation failed: {response.text}"
    suite_id = response.json()["id"]
    yield suite_id
    test_suites_endpoint.delete(suite_id)


@pytest.fixture
def created_case(test_cases_endpoint, created_suite):
    response = test_cases_endpoint.post({
        "suiteID": created_suite,
        "title": CASE_TITLE,
        "description": CASE_DESCRIPTION,
    })
    assert response.status_code == 200, f"Case creation failed: {response.text}"
    case_id = response.json()["id"]
    yield case_id
    test_cases_endpoint.delete(case_id)


@pytest.mark.test_id("TC16")
def test_post_test_case_create(test_cases_endpoint, created_suite):
    response = test_cases_endpoint.post({
        "suiteID": created_suite,
        "title": CASE_TITLE,
        "description": CASE_DESCRIPTION,
    })
    assert response.status_code == 200
    body = response.json()
    assert "id" in body
    assert body["message"] == "Test case successfully added"
    test_cases_endpoint.delete(body["id"])


@pytest.mark.test_id("TC17")
def test_post_test_case_non_existent_suite(test_cases_endpoint):
    response = test_cases_endpoint.post({
        "suiteID": "999999",
        "title": CASE_TITLE,
        "description": CASE_DESCRIPTION,
    })
    assert response.status_code == 404
    assert response.json()["message"] == "Test suite doesn't exist"


@pytest.mark.test_id("TC19")
def test_post_test_case_missing_field(test_cases_endpoint, created_suite):
    response = test_cases_endpoint.post({
        "suiteID": created_suite,
        "description": CASE_DESCRIPTION,
    })
    assert response.status_code == 400
    assert response.json()["message"] == "Bad request body"


@pytest.mark.test_id("TC20")
@pytest.mark.usefixtures("created_case")
def test_get_all_test_cases(test_cases_endpoint):
    response = test_cases_endpoint.get()
    assert response.status_code == 200
    body = response.json()
    assert "test_cases" in body
    assert isinstance(body["test_cases"], list)
    assert len(body["test_cases"]) >= 1


@pytest.mark.test_id("TC21")
def test_get_test_case_by_id(test_cases_endpoint, created_case, created_suite):
    response = test_cases_endpoint.get(created_case)
    assert response.status_code == 200
    body = response.json()
    assert "test_case" in body
    case = body["test_case"]
    assert case["id"] == created_case
    assert case["suiteID"] == created_suite
    assert "title" in case
    assert "description" in case


@pytest.mark.test_id("TC22")
def test_get_test_case_non_existent_id(test_cases_endpoint):
    response = test_cases_endpoint.get("999999")
    assert response.status_code == 404
    assert "doesn't exist" in response.json()["message"]


@pytest.mark.test_id("TC23")
def test_put_test_case_update(test_cases_endpoint, created_case, created_suite):
    response = test_cases_endpoint.put(created_case, {
        "suiteID": created_suite,
        "title": "Updated Login Test",
        "description": "Updated description",
    })
    assert response.status_code == 200
    assert response.json()["message"] == "Test case successfully updated"


@pytest.mark.test_id("TC26")
def test_delete_test_case_by_id(test_cases_endpoint, created_suite):
    response = test_cases_endpoint.post({
        "suiteID": created_suite,
        "title": "Case To Delete",
        "description": "Will be deleted in this test",
    })
    assert response.status_code == 200
    case_id = response.json()["id"]

    delete_response = test_cases_endpoint.delete(case_id)
    assert delete_response.status_code == 200
    assert delete_response.json()["message"] == "Test case successfully deleted"
