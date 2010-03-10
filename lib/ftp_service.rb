require 'net/ftp'
require 'tempfile_helper'
require 'ftp_service/encryption'

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
  include Encryption
  
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
  
  # Write +request+ to a local temp file and upload it to +remote_path+
  # on the FTP server.
  #
  #   write_request('<foo>bar</foo>', '/remote/path.xml')
  #
  # You can encrypt the request using GPG:
  #
  #   write_request('<secret>stuff</secret>', '/remote/path.xml.gpg', :gpg_recipient => 'recipient@email.com')
  # 
  # You must have +gpg+ installed and have a public key available for 
  # the intended recipient. This uses the +ruby_gpg+ gem. To configure
  # the gpg settings, see {http://rdoc.info/projects/blaix/ruby_gpg}.
  def write_request(request, remote_path, options = {})
    request = TempfileHelper.write(request, 'request')
    remote_temp_path = remote_path + ".tmp"
    if options[:gpg_recipient]
      encrypt(request, options[:gpg_recipient])
      @ftp.putbinaryfile(request.path, remote_temp_path)
    else
      @ftp.puttextfile(request.path, remote_temp_path)
    end
    @ftp.rename(remote_temp_path, remote_path)
  end
  
  # Download the file at +remote_path+ from the FTP server to a local
  # temp file and return its contents. If +remote_path+ doesn't exist,
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
