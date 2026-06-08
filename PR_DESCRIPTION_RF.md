# Add Robot Framework Test Automation Framework

Implemented a TAF on top of the existing Flask + Redis API using Robot Framework with pabot for parallel execution.
Covers auth, test suite, and test case endpoints with custom keywords, variables, setup/teardown, and DDT.

---

## What's included

- `robot_tests/resources/variables.resource` — shared URLs and credentials
- `robot_tests/resources/api.resource` — generic HTTP keywords (Get/Post/Put/Delete Resource)
- `robot_tests/resources/entities.resource` — suite and case setup/teardown keywords
- `robot_tests/auth/auth.robot` — 4 login tests (TC02–TC05) with DDT template for negative cases
- `robot_tests/test_suites/test_suites.robot` — 5 suite tests (TC06, TC09–TC12)
- `robot_tests/test_cases/test_cases.robot` — 8 case tests (TC16–TC17, TC19–TC23, TC26)
- `robot_tests/results/` — HTML and XML reports attached

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
pip install robotframework robotframework-requests robotframework-pabot
```

**Run all tests sequentially:**
```bash
robot --outputdir robot_tests/results robot_tests/
```

**Run in parallel (suite level):**
```bash
pabot --processes 2 --outputdir robot_tests/results robot_tests/
```

**Run a single suite:**
```bash
robot --outputdir robot_tests/results robot_tests/auth/auth.robot
```

**Run by tag:**
```bash
robot --outputdir robot_tests/results --include TC02 robot_tests/
```

**Run against a different host:**
```bash
robot --outputdir robot_tests/results -v BASE_URL:http://your-host:5000 robot_tests/
```

**Results:** open `robot_tests/results/report.html` in a browser.

---

## Notes

- `pabot --processes 2` runs 2 suites at a time — if tests fail with 409 errors, re-run sequentially with `robot` instead
- Credentials are stored in `tests/config/test_config.json` — update there if they change
- `BASE_URL` can be overridden at runtime via `-v BASE_URL:http://...` without touching any file
