*** Settings ***
Library           String
Resource          ../resources/entities.resource
Suite Setup       Authenticate
Test Setup        Create Suite For Test
Test Teardown     Delete Suite After Test

*** Variables ***
${AUTH_HEADERS}    ${NONE}
${SUITE_ID}        ${NONE}

*** Test Cases ***
TC06 POST Create Test Suite
    [Setup]       NONE
    [Teardown]    NONE
    [Tags]    TC06    test_suites
    ${title}=       Generate Unique Title    API Test Suite
    ${body}=        Create Dictionary    title=${title}
    ${response}=    Post Resource    ${SUITES_URL}    ${AUTH_HEADERS}    ${body}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    id
    Should Be Equal    ${json}[message]    Test suite successfully added
    Delete Resource    ${SUITES_URL}/${json}[id]    ${AUTH_HEADERS}

TC09 GET All Test Suites
    [Tags]    TC09    test_suites
    ${response}=    Get Resource    ${SUITES_URL}    ${AUTH_HEADERS}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    test_suites
    Should Be True    len($json['test_suites']) >= 1

TC10 GET Test Suite By ID
    [Tags]    TC10    test_suites
    ${response}=    Get Resource    ${SUITES_URL}/${SUITE_ID}    ${AUTH_HEADERS}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    test_suite
    Should Be Equal    ${json}[test_suite][id]    ${SUITE_ID}

TC11 GET Test Suite Non-Existent ID
    [Setup]       NONE
    [Teardown]    NONE
    [Tags]    TC11    test_suites    negative
    ${response}=    Get Resource    ${SUITES_URL}/999999    ${AUTH_HEADERS}
    Should Be Equal As Integers    ${response.status_code}    404
    Should Contain    ${response.json()}[message]    doesn't exist

TC12 PUT Update Test Suite
    [Tags]    TC12    test_suites
    ${body}=        Create Dictionary    title=Updated Suite RF
    ${response}=    Put Resource    ${SUITES_URL}/${SUITE_ID}    ${AUTH_HEADERS}    ${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[message]    Test suite successfully updated

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
    ${title}=    Generate Unique Title    API Test Suite RF
    ${id}=       Create Suite    ${AUTH_HEADERS}    ${title}
    Set Test Variable    ${SUITE_ID}    ${id}

Delete Suite After Test
    Delete Suite    ${AUTH_HEADERS}    ${SUITE_ID}
