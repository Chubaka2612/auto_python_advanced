*** Variables ***
${BASE_URL}         http://localhost:5000
${LOGIN_URL}        ${BASE_URL}/api/v1/login
${SUITES_URL}       ${BASE_URL}/api/v1/test_suites
${CASES_URL}        ${BASE_URL}/api/v1/test_cases

${USERNAME}         test
${PASSWORD}         test

&{JSON_HEADER}      Content-Type=application/json
