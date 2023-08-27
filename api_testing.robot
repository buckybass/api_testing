*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Login and Get Token
    [Arguments]    ${username}    ${password}    ${expected_status}
    ${requestbody}    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST    http://localhost:8082/login    
    ...    json=${requestbody}    
    ...    expected_status=${expected_status}
    ${token}    Set Variable    ${response.json()['message']}
    [Return]    ${token}    ${response}

Get All Assets
    [Arguments]    ${token}    ${expected_status}
    ${header}    Create Dictionary    token=${token}
    ${get_assets}=    GET   
    ...    http://localhost:8082/assets    
    ...    headers=${header}
    ...    expected_status=${expected_status}
    [Return]    ${get_assets}
*** Test Cases ***
TC-001 login fail
    ${token}    ${response}=    Login and Get Token    doppio    1234    401
    Should Be Equal    ${response.json()['message']}    invalid username or password
    Should Be Equal    ${response.json()['status']}    error

TC-002 login Pass and get all Assets
    ${token}    ${response}=    Login and Get Token    doppio    weBuildBestQa    200
    Should Be Equal    ${response.json()['status']}    success
    ${get_assets}=    Get All Assets    ${token}    200
    ${count}=    Get Length    ${get_assets.json()}
    ${morethanone}    Evaluate    ${count}>0
    Should Be True    ${morethanone}
    Log To Console    ${get_assets.json()}

TC-003 Verify that get asset API always require valid token
    # status code = 401
    # status message = error
    # message = you do not have access to this resource
    Create Session    assetsSession    http://localhost:8082
    ${token}    Set Variable    1234545745
    ${header}    Create Dictionary    token=${token}
    ${get_assets}=    Get All Assets    ${token}    401
    Should Be Equal    ${get_assets.json()['status']}    error
    Should Be Equal    ${get_assets.json()['message']}    you do not have access to this resource

TC-004 Verify that create asset API can work correctly
    #valid token
    #status code = 200
    #status message = success
    ${token}    ${response}=    Login and Get Token    doppio    weBuildBestQa    200
    ${header}=    Create Dictionary    token=${token}
    ${body}=    Create Dictionary    assetId=a006    assetName=Macpro m1    assetType=1    inUse=true
    ${response_createAsset}=    POST    http://localhost:8082/assets    
    ...    headers=${header}    
    ...    json=${body}    
    ...    expected_status=200
    Log To Console    ${response.json()}
    Should Be Equal    ${response_createAsset.json()['status']}    success

TC-005 Verify that cannot create asset with duplicated ID 
    #call create asset with valid token but use duplicate asset ID 
    # check status message 
    # check error message 
    # check that no duplicated asset returned from GET /assets
    ${token}    ${response}=    Login and Get Token    doppio    weBuildBestQa    200
    ${header}=    Create Dictionary    token=${token}
    ${assetID}    Set Variable    a006
    ${body}=    Create Dictionary    assetId=${assetID}    assetName=Macpro m1    assetType=1    inUse=true
    ${response_createAsset}=    POST    http://localhost:8082/assets    
    ...    headers=${header}    
    ...    json=${body}    
    ...    expected_status=200
    Log To Console    ${response.json()}
    Should Be Equal    ${response_createAsset.json()['status']}    failed
    Should Be Equal    ${response_createAsset.json()['message']}    
    ...    id : ${assetID} is already exists , please try with another id

TC-006 Verify that modify asset API can work correctly 
    #call modify asset with valid token and try to change name of some asset 
    #check status message = success 
    #call get api to check that asset Name has been changed 
    ${token}    ${response}=    Login and Get Token    doppio    weBuildBestQa    200
    ${header}=    Create Dictionary    token=${token}
    ${body}=    Create Dictionary    assetId=a006        assetName=Macpro m2
    ${response_modify}=    PUT    http://localhost:8082/assets    
    ...    headers=${header}    
    ...    json=${body}
    ...    expected_status=200
    Log To Console    ${response_modify.json()}

TC-007 Verify that delete asset API can work correctly
    #call delete asset 
    #call GET to check that asset has been deleted 
    ${token}    ${response}=    Login and Get Token    doppio    weBuildBestQa    200
    ${header}=    Create Dictionary    token=${token}
    ${assetId}=    Set Variable    a001
    ${response_delete}=    DELETE    http://localhost:8082/assets/${assetId}    
    ...    headers=${header}
    Should Be Equal    ${response_delete.json()['status']}    success

TC-008 Verify that cannot delete asset which ID does not exists 
    #call delete asset with non-existing id 
    #check error message 
    ${token}    ${response}=    Login and Get Token    doppio    weBuildBestQa    200
    ${header}=    Create Dictionary    token=${token}
    ${assetId}=    Set Variable    12312412441
    ${response_delete}=    DELETE    http://localhost:8082/assets/${assetId}    
    ...    headers=${header}
    Should Be Equal    ${response_delete.json()['status']}    failed
    Should Be Equal    ${response_delete.json()['message']}    cannot find this id in database
