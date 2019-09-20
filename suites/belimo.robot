*** Settings ***
Documentation   Simple test case for Belimo Website
Library     Selenium2Library
Library     XvfbRobot
Library     OperatingSystem
Suite Setup     Start Virtual Display    1920    1080
Force Tags      BelimoShowCase


*** Variables ***
${download_dir}     /tmp


*** Test Cases ***
Check that sensor is available in Belimo
    Given user is in belimo web page
    When user searches for "Drehantrieb"
    Then there are results containing the item
    And the user can view the item details
    And the user can download the installation manual
    [Teardown]      Close Browser


*** Keywords ***
user is in belimo web page
    Open Chrome Browser
    Go To       https://www.belimo.ch

user searches for "${search_text}"
    Input Text      SearchTerm     ${search_text}
    Press Key       SearchTerm     \\13
    
there are results containing the item
    Wait Until Page Contains     DR24A-7   timeout=10
    
the user can view the item details
    Click Link      DR24A-7
    Title Should Be     DR24A-7 - Drehantrieb 90 Nm
    Capture Page Screenshot

the user can download the installation manual
    ${manual_link}=  SetVariable     Antrieb: Montageanleitung (PDF - 392 kb)
    Page Should Contain Link   ${manual_link} 
    Element Attribute Value Should Be    link:${manual_link}   href    https://www.belimo.ch/pdf/z/DR..A_mounting_instruction.pdf
    Click Link   ${manual_link}
    # ${is_downloaded}   Wait Until Keyword Succeeds  5 sec   2 sec   Download should be done    ${download_dir}  DR..A_mounting_instruction.pdf
    
Open Chrome Browser
    ${options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method  ${options}  add_argument  --no-sandbox
    ${prefs}    Create Dictionary    download.default_directory=${download_dir}
    Call Method    ${options}    add_experimental_option    prefs     ${prefs}
    Create Webdriver    Chrome    chrome_options=${options}

Download should be done
    [Documentation]     Verifies that a file exists in a certain directory
    ...
    ...     TODO: This does not seem to work. Fix in selenium-chrome.
    [Arguments]    ${directory}     ${filename}
    ${files}    List Files In Directory    ${directory}
    Log     ${files}
    ${file_path}    Join Path   ${directory}     ${filename}
    Log     ${file_path}
    File Should Exist   ${file_path}
    [Return]  ${file_path}
