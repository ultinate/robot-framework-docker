*** Settings ***
Force Tags          BelimoSwarm
Library           OperatingSystem
Library           lib/LoginLibrary.py
Library          Selenium2Library
Library          XvfbRobot
Suite Setup     Perform Suite Setup
Test Teardown     Clear Login Database


*** Variables ***
${APP_URL}                http://web:80  # http://localhost:4000
${USERNAME}               janedoe
${PASSWORD}               J4n3D0e
${NEW PASSWORD}           e0D3n4J
${DATABASE FILE}          ${TEMPDIR}${/}robot-user-db.txt
${PWD INVALID LENGTH}     Password must be 7-12 characters long
${PWD INVALID CONTENT}    Password must be a combination of lowercase and uppercase letters and numbers


*** Test Cases ***
User can open web app
    Open Chrome Browser
    Go To      ${APP_URL} 
    Title Should Be     Belimo Java Web App
    Capture Page Screenshot

User can create an account and log in
    Create Valid User    fred    P4ssw0rd
    Attempt to Login with Credentials    fred    P4ssw0rd
    Status Should Be    Logged In

User cannot log in with bad password
    Create Valid User    betty    P4ssw0rd
    Attempt to Login with Credentials    betty    wrong
    Status Should Be    Access Denied

Invalid password
    [Template]    Creating user with invalid password should fail
    abCD5            ${PWD INVALID LENGTH}
    abCD567890123    ${PWD INVALID LENGTH}
    123DEFG          ${PWD INVALID CONTENT}
    abcd56789        ${PWD INVALID CONTENT}
    AbCdEfGh         ${PWD INVALID CONTENT}
    abCD56+          ${PWD INVALID CONTENT}

IoTBelimo-119 Login
    Open Chrome Browser
    Go To      ${APP_URL} 
    Title Should Be     Belimo Java Web App
    Page Should Contain     Belimo Java Web App
    Page Should Contain Image     /static/images/belimo_logo.gif
    Capture Page Screenshot
    Attempt to Login with Credentials    betty    wrong
    Status Should Be    Access Denied
    Create Valid User    fred    P4ssw0rd
    Attempt to Login with Credentials    fred    P4ssw0rd
    Status Should Be    Logged In
    Close Browser
    Open Chrome Browser
    Go To      ${APP_URL} 
    Page Should Contain     Login
    

*** Keywords ***
Perform Suite Setup
    Start Virtual Display    1920    1080
    Clear Login Database

Clear login database
    Remove file    ${DATABASE FILE}

Create valid user
    [Arguments]    ${username}    ${password}
    Create user    ${username}    ${password}
    Status should be    SUCCESS

Creating user with invalid password should fail
    [Arguments]    ${password}    ${error}
    Create user    example    ${password}
    Status should be    Creating user failed: ${error}

Login
    [Arguments]    ${username}    ${password}
    Attempt to login with credentials    ${username}    ${password}
    Status should be    Logged In

A user has a valid account
    Create valid user    ${USERNAME}    ${PASSWORD}

She changes her password
    Change password    ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}
    Status should be    SUCCESS

She can log in with the new password
    Login    ${USERNAME}    ${NEW PASSWORD}

She cannot use the old password anymore
    Attempt to login with credentials    ${USERNAME}    ${PASSWORD}
    Status should be    Access Denied

Open Chrome Browser
    ${options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method  ${options}  add_argument  --no-sandbox
    ${prefs}    Create Dictionary    download.default_directory=/tmp
    Call Method    ${options}    add_experimental_option    prefs     ${prefs}
    Create Webdriver    Chrome    chrome_options=${options}

