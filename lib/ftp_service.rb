require 'net/ftp'
require 'tempfile_helper'

# TODO: Remove need for temp files by using Net::FTP#retrlines/storlines
# TODO: Use intermediate temp file for the uploaded request.

# Class for dealing with a service that acts like a web service, except
# over FTP. Meaning an xml request is uploaded as a file, and the
# response xml is downloaded as another file.
#
# Typical usage:
# 
#   FtpService.open('host', 'user', 'pass') do |service|
#     path = '/the/remote/path'
#     service.write_request("#{path}/request.xml", '<foo>bar</foo>')
#     response = service.read_response("#{path}/response.xml")
#   end
#
# or (the sucky way):
#
#   path = '/the/remote/path'
#   service = FtpService.new('host', 'user', 'pass')
#   service.write_request("#{path}/request.xml", '<foo>bar</foo>')
#   response = service.read_response("#{path}/response.xml")
#   service.close
class FtpService
  
  # Open a connection to the FTP server and return an FtpService object.
  # The object must be closed explicitely. See FtpServier#open for a
  # better way to do this that will automatically close the connection,
  # even if an exception is raised.
  def initialize(host, user, pass)
    @ftp = Net::FTP.open(host, user, pass)
  end
  
  # Open a connection and pass an FtpService instance to the block. The
  # instance will be closed when the block finishes, or when an
  # exception is raised.
  def self.open(host, user, pass)
    instance = new(host, user, pass)
    begin
      yield(instance)
    ensure
      instance.close
    end
  end
  
  # Write `request` to a local temp file and upload it to `remote_path`
  # on the FTP server.
  def write_request(request, remote_path)
    tmp = TempfileHelper.write(request, 'request')
    @ftp.puttextfile(tmp.path, remote_path)
  end
  
  # Download the file at `remote_path` from the FTP server to a local
  # temp file and return its contents. If `remote_path` doesn't exist,
  # keep trying for 2 minutes before raising a Timeout::Error.
  def read_response(remote_path)
    TempfileHelper.read('response') do |tmp|
      Timeout::timeout(120) do
        loop_until_downloaded(remote_path, tmp.path)
      end
    end
  end
  
  # Close the connection to the FTP server.
  def close
    @ftp.close
  end
  
  private
  
  def loop_until_downloaded(remote_path, local_path)
    loop do
      begin
        @ftp.gettextfile(remote_path, local_path)
        break
      rescue Net::FTPPermError => e
        raise unless e.message.include?("No such file")
        rest_between_requests
      end
    end
  end
  
  def rest_between_requests
    sleep(2)
  end
end
