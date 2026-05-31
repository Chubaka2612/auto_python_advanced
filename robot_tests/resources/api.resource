*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    variables.resource

*** Keywords ***
Get Auth Token
    ${body}=        Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST    ${LOGIN_URL}    json=${body}    headers=${JSON_HEADER}    expected_status=200
    ${json}=        Set Variable    ${response.json()}
    RETURN    ${json}[access_token]

Build Auth Headers
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json
    RETURN    ${headers}

Get Resource
    [Arguments]    ${url}    ${headers}
    ${response}=    GET    ${url}    headers=${headers}    expected_status=any
    RETURN    ${response}

Post Resource
    [Arguments]    ${url}    ${headers}    ${body}
    ${response}=    POST    ${url}    json=${body}    headers=${headers}    expected_status=any
    RETURN    ${response}

Put Resource
    [Arguments]    ${url}    ${headers}    ${body}
    ${response}=    PUT    ${url}    json=${body}    headers=${headers}    expected_status=any
    RETURN    ${response}

Delete Resource
    [Arguments]    ${url}    ${headers}
    DELETE    ${url}    headers=${headers}    expected_status=any
