Feature: file upload end-point

Background:
* url demoBaseUrl


Scenario: upload with filename and content-type specified
    Given path 'files','multiple'
    And multipart files {myFile1:{read:'test.pdf',filename:'upload-name1.pdf',contentType:'application/pdf'}, myFile2:{read: 'test.pdf',filename: 'upload-name2.pdf',contentType: 'application/pdf' }}
    And multipart field message = 'hello world'
    When method post
    Then status 200
    And match response == [{ id: '#uuid', filename: 'upload-name1.pdf', message: 'hello world', contentType: 'application/pdf' }, { id: '#uuid', filename: 'upload-name2.pdf', message: 'hello world', contentType: 'application/pdf' }]
    And def id1 = response[0].id
    And def id2 = response[1].id

    Given path 'files', id1
    When method get
    Then status 200
    And match response == read('test.pdf')
    And match header Content-Disposition contains 'attachment'
    And match header Content-Disposition contains 'upload-name1.pdf'
    And match header Content-Type == 'application/pdf'

    Given path 'files', id2
    When method get
    Then status 200
    And match response == read('test.pdf')
    And match header Content-Disposition contains 'attachment'
    And match header Content-Disposition contains 'upload-name2.pdf'
    And match header Content-Type == 'application/pdf'