*** Settings ***
Resource    api.resource

*** Keywords ***
Create Suite
    [Arguments]    ${headers}    ${title}
    ${body}=        Create Dictionary    title=${title}
    ${response}=    Post Resource    ${SUITES_URL}    ${headers}    ${body}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response.json()}[id]

Delete Suite
    [Arguments]    ${headers}    ${suite_id}
    Delete Resource    ${SUITES_URL}/${suite_id}    ${headers}

Create Case
    [Arguments]    ${headers}    ${suite_id}    ${title}    ${description}
    ${body}=        Create Dictionary    suiteID=${suite_id}    title=${title}    description=${description}
    ${response}=    Post Resource    ${CASES_URL}    ${headers}    ${body}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response.json()}[id]

Delete Case
    [Arguments]    ${headers}    ${case_id}
    Delete Resource    ${CASES_URL}/${case_id}    ${headers}
