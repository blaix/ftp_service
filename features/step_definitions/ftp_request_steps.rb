Given /^I connect to an FTP service$/ do
  @service = FtpService.new(FtpHelper::SERVER, FtpHelper::USER, FtpHelper::PASS)
end

When /^I send the request "([^\"]*)" to the path "([^\"]*)"$/ do |request, remote_path|
  @service.write_request(request, remote_path)
end

Then /^the request "([^\"]*)" should exist at "([^\"]*)"$/ do |request, remote_path|
  actual_request = ""
  ftp.retrlines("RETR #{remote_path}") { |line| actual_request << line }
  actual_request.should == request
end

When /^the server responds with "([^\"]*)" at the path "([^\"]*)"$/ do |response, remote_path|
  response = StringIO.new(response)
  ftp.storlines("STOR #{remote_path}", response)
end

Then /^I can read the response at the path "([^\"]*)"$/ do |remote_path|
  @actual_response = @service.read_response(remote_path)
end

Then /^the response should be "([^\"]*)"$/ do |response|
  @actual_response.strip.should == response
end

After do
  @service.close
end
