*** Settings ***
Resource    ../resources/api.resource

*** Variables ***
&{WRONG_PASSWORD_BODY}    username=${USERNAME}    password=wrongpassword
&{MISSING_FIELD_BODY}     username=${USERNAME}

*** Test Cases ***
TC02 POST Login Valid Credentials
    [Tags]    TC02    auth
    ${body}=        Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    Post Resource    ${LOGIN_URL}    ${JSON_HEADER}    ${body}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${json}    access_token
    Should Not Be Equal    ${json}[access_token]    ${NONE}

TC03 TC04 POST Login Invalid JSON Body
    [Tags]    TC03    TC04    auth    negative
    [Template]    Login Should Return Error
    ${WRONG_PASSWORD_BODY}    401    No such username or password
    ${MISSING_FIELD_BODY}     400    Bad request body

TC05 POST Login Wrong Content Type
    [Tags]    TC05    auth    negative
    ${headers}=     Create Dictionary    Content-Type=text/plain
    ${response}=    POST    ${LOGIN_URL}    data=username=${USERNAME}&password=${PASSWORD}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    415
    Should Be Equal    ${response.json()}[message]    Content-type must be application/json

*** Keywords ***
Login Should Return Error
    [Arguments]    ${body}    ${expected_status}    ${expected_message}
    ${response}=    Post Resource    ${LOGIN_URL}    ${JSON_HEADER}    ${body}
    ${json}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    Should Be Equal    ${json}[message]    ${expected_message}
