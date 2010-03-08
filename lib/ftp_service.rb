require 'net/ftp'
require 'tempfile_helper'

# Class for dealing with a service that acts like a web service, except
# over FTP. Meaning an xml request is uploaded as a file, and the
# response xml is downloaded as another file.
class FtpService
  
  # Open a connection to the FTP server and return an FtpService object.
  # The object must be closed explicitely.
  #
  #   ftp_service = FtpService.open(host, user, pass)
  #   ftp_service.write_request(path, request)
  #   response = ftp_service.read_response(path)
  #   ftp_service.close
  def initialize(host, user, pass)
    @ftp = Net::FTP.open(host, user, pass)
  end
  
  # Open a connection and pass an FtpService instance to the block. The
  # instance will be closed when the block finishes, or when an
  # exception is raised.
  #
  #   FtpService.open(host, user, pass) do |ftp_service|
  #     ftp_service.write_request(path, request)
  #     response = ftp_service.read_response(path)
  #   end
  def self.open(host, user, pass)
    instance = new(host, user, pass)
    begin
      yield(instance)
    ensure
      instance.close
    end
  end
  
  # Write the +request+ to the +remote_path+ on the FTP server.
  def write_request(request, remote_path)
    tmp = TempfileHelper.write(request, 'request')
    @ftp.puttextfile(tmp.path, remote_path)
  end
  
  # Close the connection to the FTP server.
  def close
    @ftp.close
  end
end
