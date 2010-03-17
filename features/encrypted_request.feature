# To run, you must have an FTP server running and accessible by the 
# credentials defined in features/support/ftp_helper.rb

# The encryption uses the gpg keys in the test_keys dir.

Feature: GPG Encryption
  In order to keep my request secure over insecure FTP
  As a user
  I want to use gpg to encrypt and decrypt my request and response files

  Background:
    Given I connect to an FTP service

  Scenario: send a request
    When I send the request "secret content" to the path "request_path.gpg" with gpg recipient "Slow Joe Crow"
    Then a binary request should exist at "request_path.gpg"
    And the binary request at "request_path.gpg" should not contain "secret content"
    When I download the binary request at "request_path.gpg" to "downloaded_request.gpg"
    And I decrypt the file "downloaded_request.gpg" with passphrase "test"
    Then the file "downloaded_request" should contain "secret content"
  
  Scenario: read a response
    When the server responds with "secret response" encrypted for "Slow Joe Crow" at the path "response_path.gpg"
    Then I can read the response at the path "response_path.gpg" with the passphrase "test"
    And the response should be "secret response"
