require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FtpService" do
  before do
    @ftp = stub_everything('ftp')
    Net::FTP.stubs(:open).returns(@ftp)
  end
  
  describe '.new(host, user, pass)' do
    it 'should connect to the requested ftp server' do
      Net::FTP.expects(:open).with('host', 'user', 'pass').returns(@ftp)
      FtpService.new('host', 'user', 'pass')
    end

    it 'should yield an instance of the ftp service' do
      service = FtpService.new('host', 'user', 'pass')
      service.should be_a(FtpService)
    end
  end
  
  describe '.open(host, user, pass)' do
    it 'should connect to the requested ftp server' do
      Net::FTP.expects(:open).with('host', 'user', 'pass').returns(@ftp)
      FtpService.open('host', 'user', 'pass') {}
    end

    it 'should yield an instance of the ftp service' do
      service = nil
      FtpService.open('host', 'user', 'pass') { |service| }
      service.should be_a(FtpService)
    end
    
    it 'should automatically close the connection' do
      @ftp.expects(:close)
      FtpService.open('host', 'user', 'pass') {}
    end
    
    it 'should close the connection even if an exception is raised' do
      @ftp.expects(:close)
      lambda {
        FtpService.open('host', 'user', 'pass') { raise "boom" }
      }.should raise_error
    end
  end
  
  describe '#write_request(path, request)' do
    it "should upload the request to the path" do
      tmpfile = Tempfile.new('request')
      Tempfile.stubs(:new).returns(tmpfile)

      @ftp.expects(:puttextfile).with(tmpfile.path, '/remote/path')
      FtpService.open('host', 'user', 'pass') do |service|
        service.write_request('<request>blah</request>', '/remote/path')
      end
      
      File.read(tmpfile.path).should == "<request>blah</request>"
    end
  end
  
  describe '#close' do
    it 'should close the connection to the ftp server' do
      @ftp.expects(:close)
      FtpService.new('host', 'user', 'pass').close
    end
  end
end
