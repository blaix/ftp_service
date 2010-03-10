# To run, you must have an FTP server running and accessible by the 
# credentials defined in features/support/ftp_helper.rb

Feature: Making a request
  In order to take advantage of a web service over FTP
  As a poor unfortunate soul
  I want to make a request
  
  Background:
    Given I connect to an FTP service

  Scenario: send a request
    When I send the request "request" to the path "request_path"
    Then the request "request" should exist at "request_path"
  
  Scenario: read a response
    When the server responds with "response" at the path "response_path"
    Then I can read the response at the path "response_path"
    And the response should be "response"
