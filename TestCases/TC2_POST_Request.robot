*** Settings ***
Library  RequestsLibrary
Library  Collections


*** Variables ***
${base_url}     https://demoqa.com


*** Test Cases ***
Post_CreateUser
    create session  mysession  ${base_url}
    ${body}=     create dictionary   userName=timbucher  password=Password@123
    ${header}=   create dictionary   Content-Type=application/json
    ${response}=     post request  mysession  /Account/v1/User  data=${body}  headers=${header}

    log to console  ${response.status_code}
    log to console  ${response.content}

    # Validations
    ${status_code}=  convert to string  ${response.status_code}
    should be equal  ${status_code}  201

    ${res_body}=     convert to string  ${response.content}
    should contain  ${res_body}  timbucher
