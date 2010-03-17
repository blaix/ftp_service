Given /^I connect to an FTP service$/ do
  @service = FtpService.new(FtpHelper::SERVER, FtpHelper::USER, FtpHelper::PASS)
end

When /^I send the request "([^\"]*)" to the path "([^\"]*)"$/ do |request, remote_path|
  @service.write_request(request, remote_path)
end

When /^I send the request "([^\"]*)" to the path "([^\"]*)" with gpg recipient "([^\"]*)"$/ do |request, remote_path, gpg_recipient|
  @service.write_request(request, remote_path, :gpg_recipient => gpg_recipient)
end

When /^the server responds with "([^\"]*)" at the path "([^\"]*)"$/ do |response, remote_path|
  response = StringIO.new(response)
  ftp.storlines("STOR #{remote_path}", response)
end

When /^the server responds with "([^\"]*)" encrypted for "([^\"]*)" at the path "([^\"]*)"$/ do |response, gpg_recipient, remote_path|
  # Cheating a bit here to mimic a ftp service response by sending a request...
  @service.write_request(response, remote_path, :gpg_recipient => gpg_recipient)
end

When /^I download the binary request at "([^\"]*)" to "([^\"]*)"$/ do |remote_path, local_path|
  File.delete(local_path) if File.exist?(local_path)
  ftp.getbinaryfile(remote_path, "#{TMP_PATH}/#{local_path}")
end

When /^I decrypt the file "([^\"]*)" with passphrase "([^\"]*)"$/ do |filename, passphrase|
  RubyGpg.decrypt("#{TMP_PATH}/#{filename}", passphrase)
end

Then /^the request "([^\"]*)" should exist at "([^\"]*)"$/ do |request, remote_path|
  actual_request = ""
  ftp.retrlines("RETR #{remote_path}") { |line| actual_request << line }
  actual_request.should == request
end

Then /^a binary request should exist at "([^\"]*)"$/ do |remote_path|
  lambda {
    ftp.retrbinary("RETR #{remote_path}", 128) {}
  }.should_not raise_error
end

Then /^the binary request at "([^\"]*)" should not contain "([^\"]*)"$/ do |remote_path, request|
  actual = ""
  ftp.retrbinary("RETR #{remote_path}", 128) { |chunk| actual << chunk }
  actual.strip.should_not == request.strip
end

Then /^I can read the response at the path "([^\"]*)"$/ do |remote_path|
  @actual_response = @service.read_response(remote_path)
end

Then /^I can read the response at the path "([^\"]*)" with the passphrase "([^\"]*)"$/ do |remote_path, gpg_passphrase|
  @actual_response = @service.read_response(remote_path, :gpg_passphrase => gpg_passphrase)
end

Then /^the response should be "([^\"]*)"$/ do |response|
  @actual_response.strip.should == response
end

Then /^the file "([^\"]*)" should contain "([^\"]*)"$/ do |filename, contents|
  File.read("#{TMP_PATH}/#{filename}").strip.should == contents.strip
end

After do
  @service.close if @service
end
