*** Settings ***
Library           String
Resource          ../resources/entities.resource
Suite Setup       Authenticate
Test Setup        Create Suite And Case For Test
Test Teardown     Delete Case And Suite For Test

*** Variables ***
${AUTH_HEADERS}       ${NONE}
${SUITE_ID}           ${NONE}
${CASE_ID}            ${NONE}
${CASE_TITLE}         Login Functionality Test
${CASE_DESCRIPTION}   Tests the POST /login endpoint

*** Test Cases ***
TC16 POST Create Test Case
    [Setup]       Create Suite For Test
    [Teardown]    Delete Suite For Test
    [Tags]    TC16    test_cases
    ${body}=        Create Dictionary    suiteID=${SUITE_ID}    title=${CASE_TITLE}    description=${CASE_DESCRIPTION}
    ${response}=    Post Resource    ${CASES_URL}    ${AUTH_HEADERS}    ${body}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    id
    Should Be Equal    ${json}[message]    Test case successfully added
    Delete Resource    ${CASES_URL}/${json}[id]    ${AUTH_HEADERS}

TC17 TC19 POST Create Case Invalid Input
    [Setup]       Create Suite For Test
    [Teardown]    Delete Suite For Test
    [Tags]    TC17    TC19    test_cases    negative
    [Template]    Create Case Should Return Error
    999999          yes    404    Test suite doesn't exist
    ${SUITE_ID}    no     400    Bad request body

TC20 GET All Test Cases
    [Tags]    TC20    test_cases
    ${response}=    Get Resource    ${CASES_URL}    ${AUTH_HEADERS}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    test_cases
    Should Be True    len($json['test_cases']) >= 1

TC21 GET Test Case By ID
    [Tags]    TC21    test_cases
    ${response}=    Get Resource    ${CASES_URL}/${CASE_ID}    ${AUTH_HEADERS}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    test_case
    Should Be Equal    ${json}[test_case][id]    ${CASE_ID}
    Should Be Equal    ${json}[test_case][suiteID]    ${SUITE_ID}

TC22 GET Test Case Non-Existent ID
    [Setup]       NONE
    [Teardown]    NONE
    [Tags]    TC22    test_cases    negative
    ${response}=    Get Resource    ${CASES_URL}/999999    ${AUTH_HEADERS}
    Should Be Equal As Integers    ${response.status_code}    404
    Should Contain    ${response.json()}[message]    doesn't exist

TC23 PUT Update Test Case
    [Tags]    TC23    test_cases
    ${body}=        Create Dictionary    suiteID=${SUITE_ID}    title=Updated Case RF    description=Updated description
    ${response}=    Put Resource    ${CASES_URL}/${CASE_ID}    ${AUTH_HEADERS}    ${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Test case successfully updated

TC26 DELETE Test Case By ID
    [Setup]       Create Suite For Test
    [Teardown]    Delete Suite For Test
    [Tags]    TC26    test_cases
    ${body}=        Create Dictionary    suiteID=${SUITE_ID}    title=Case To Delete    description=Will be deleted
    ${create}=      Post Resource    ${CASES_URL}    ${AUTH_HEADERS}    ${body}
    ${case_id}=     Set Variable    ${create.json()}[id]
    ${response}=    Delete Resource    ${CASES_URL}/${case_id}    ${AUTH_HEADERS}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Test case successfully deleted

*** Keywords ***
Authenticate
    ${token}=       Get Auth Token
    ${headers}=     Build Auth Headers    ${token}
    Set Suite Variable    ${AUTH_HEADERS}    ${headers}

Generate Unique Title
    [Arguments]    ${prefix}
    ${suffix}=    Generate Random String    8    [LOWER][NUMBERS]
    RETURN    ${prefix} ${suffix}

Create Suite For Test
    ${title}=    Generate Unique Title    Test Suite for Cases RF
    ${id}=       Create Suite    ${AUTH_HEADERS}    ${title}
    Set Test Variable    ${SUITE_ID}    ${id}

Delete Suite For Test
    Delete Suite    ${AUTH_HEADERS}    ${SUITE_ID}

Create Suite And Case For Test
    Create Suite For Test
    ${id}=    Create Case    ${AUTH_HEADERS}    ${SUITE_ID}    ${CASE_TITLE}    ${CASE_DESCRIPTION}
    Set Test Variable    ${CASE_ID}    ${id}

Delete Case And Suite For Test
    Delete Case     ${AUTH_HEADERS}    ${CASE_ID}
    Delete Suite    ${AUTH_HEADERS}    ${SUITE_ID}

Create Case Should Return Error
    [Arguments]    ${suite_id}    ${include_title}    ${expected_status}    ${expected_message}
    IF    '${include_title}' == 'yes'
        ${body}=    Create Dictionary    suiteID=${suite_id}    title=${CASE_TITLE}    description=${CASE_DESCRIPTION}
    ELSE
        ${body}=    Create Dictionary    suiteID=${suite_id}    description=${CASE_DESCRIPTION}
    END
    ${response}=    Post Resource    ${CASES_URL}    ${AUTH_HEADERS}    ${body}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    Should Be Equal    ${response.json()}[message]    ${expected_message}
