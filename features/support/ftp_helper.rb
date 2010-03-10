require 'net/ftp'

module FtpHelper
  SERVER = 'localhost'
  USER   = 'cucumber'
  PASS   = 'cucumber_pass123'
  
  def ftp
    @connection ||= Net::FTP.new(SERVER, USER, PASS)
  end
end

World(FtpHelper)