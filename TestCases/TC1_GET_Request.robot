*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections

*** Variables ***
${base_url}     https://demoqa.com
${isbn}     9781449325862

*** Test Cases ***
Get_bookInfo
    create session  mysession   ${base_url}
    ${response}=    GET On Session  mysession   url=/BookStore/v1/Book?ISBN=${isbn}

    log to console   ${response.status_code}
    log to console   ${response.content}
    log to console   ${response.headers}

    # Validations
    ${status_code}=  convert to string  ${response.status_code}
    should be equal  ${status_code}  200

    # Check contents
    ${body}=  convert to string  ${response.content}
    should contain  ${body}  9781449325862

    # validate ISBN
    ${isbn_value}=  get value from json  ${response.json()}  $.isbn
    should be equal  ${isbn_value[0]}  9781449325862

    # Headers
    ${contentTypeValue}=  get from dictionary  ${response.headers}  Content-Type
    log to console  ${contentTypeValue}
    should contain  ${contentTypeValue}  application/json