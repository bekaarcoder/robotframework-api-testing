*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections


*** Variables ***
${base_url}     https://demoqa.com
${isbn_to_add}     9781491950296
${username}     timbucher
${password}     Password@123
${user_id}      53b3d5fc-133f-4a9e-be87-06a273ce6d57

*** Test Cases ***
TC1:Returns all the books(GET)
    create session  mysession   ${base_url}
    ${response}=    get on session  mysession  /BookStore/v1/Books
    log to console  ${response.status_code}
    log to console  ${response.content}

    # Validation
    ${status_code}=     convert to string  ${response.status_code}
    should be equal  ${status_code}  200


TC2:Generate Bearer token
    create session  mysession  ${base_url}
    ${body}=    create dictionary   userName=${username}  password=${password}
    ${header}=  create dictionary   Content-Type=application/json
    ${response}=    post on session  mysession  /Account/v1/GenerateToken  json=${body}    headers=${header}

    log to console  ${response.status_code}
    log to console  ${response.content}

    ${status_code} =    convert to string   ${response.status_code}
    should be equal  ${status_code}  200

    ${token}=    get value from json  ${response.json()}  $.token
    log to console  ${token}

    ${bearer_token} =   set variable    Bearer ${token[0]}
    log to console  ${bearer_token}
    set suite variable  ${bearer}   Bearer ${token[0]}


TC3:Add books
    create session  mysession   ${base_url}
    ${isbn} =    create dictionary   isbn=${isbn_to_add}
    ${isbn_collection} =    create list  ${isbn}
    ${body} =   create dictionary   userId=${user_id}  collectionOfIsbns=${isbn_collection}
    ${header} =  create dictionary  Content-Type=application/json  Authorization=${bearer}
    ${response} =   post request   mysession   /BookStore/v1/Books  json=${body}  headers=${header}

    log to console  ${response.status_code}
    log to console  ${response.content}

    ${status_code} =    convert to string  ${response.status_code}
    should be equal  ${status_code}  201

    ${response_isbn} =  get value from json  ${response.json()}  $.books[0].isbn
    should be equal  ${response_isbn[0]}  ${isbn_to_add}


TC4:Update Book
    create session  mysession   ${base_url}
    ${body} =     create dictionary  userId=${user_id}  isbn=9781449331818
    ${header} =     create dictionary  Content-Type=application/json  Authorization=${bearer}
    ${response} =   put request  mysession  /BookStore/v1/Books/${isbn_to_add}  json=${body}  headers=${header}

    log to console  ${response.status_code}
    log to console  ${response.content}

    ${status_code} =    convert to string   ${response.status_code}
    should be equal  ${status_code}  200

    ${response_isbn} =  get value from json  ${response.json()}  $.books[0].isbn
    should contain  ${response_isbn}  9781449331818


TC5:Delete book
    create session  mysession   ${base_url}
    ${body} =   create dictionary    userId=${user_id}  isbn=9781449331818
    ${header} =     create dictionary  Content-Type=application/json  Authorization=${bearer}
    ${response} =   delete request  mysession  /BookStore/v1/Book  json=${body}  headers=${header}

    log to console  ${response.status_code}
    log to console  ${response.content}

    ${status_code} =    convert to string  ${response.status_code}
    should be equal  ${status_code}  204


