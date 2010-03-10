require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FtpService" do
  before do
    @ftp = stub_everything('ftp')
    Net::FTP.stubs(:open).returns(@ftp)
  end
  
  describe '.new(host, user, pass)' do
    it 'connects to the requested ftp server' do
      Net::FTP.expects(:open).with('host', 'user', 'pass').returns(@ftp)
      FtpService.new('host', 'user', 'pass')
    end

    it 'returns an instance of the ftp service' do
      service = FtpService.new('host', 'user', 'pass')
      service.should be_a(FtpService)
    end
  end
  
  describe '.open(host, user, pass)' do
    it 'connects to the requested ftp server' do
      Net::FTP.expects(:open).with('host', 'user', 'pass').returns(@ftp)
      FtpService.open('host', 'user', 'pass') {}
    end

    it 'yields an instance of the ftp service' do
      service = nil
      FtpService.open('host', 'user', 'pass') { |service| }
      service.should be_a(FtpService)
    end
    
    it 'automatically closes the connection' do
      @ftp.expects(:close)
      FtpService.open('host', 'user', 'pass') {}
    end
    
    it 'closes the connection even if an exception is raised' do
      @ftp.expects(:close)
      lambda {
        FtpService.open('host', 'user', 'pass') { raise "boom" }
      }.should raise_error
    end
  end
  
  describe '#write_request(path, request)' do
    before do
      @tempfile = stub('tempfile', :path => '/local/path')
      @service = FtpService.new('host', 'user', 'pass')
    end
    
    it "saves the request to a temp file" do
      TempfileHelper.expects(:write).with('request', optionally(anything)).returns(@tempfile)
      @service.write_request('request', '/remote/path')
    end
    
    it "uploads the request to `path` on the FTP server" do
      TempfileHelper.stubs(:write).returns(@tempfile)
      @ftp.expects(:puttextfile).with('/local/path', '/remote/path')
      @service.write_request('request', '/remote/path')
    end
  end
  
  describe '#read_response(path)' do
    before do
      tempfile = stub('tempfile', :path => '/local/path')
      TempfileHelper.stubs(:read).returns('response').yields(tempfile)

      @service = FtpService.new('host', 'user', 'pass')
      # No need to be nice to the "server" during testing...
      @service.stubs(:rest_between_requests)
    end
    
    it "downloads the response at `path` from the FTP server" do
      @ftp.expects(:gettextfile).with('/remote/path', '/local/path')
      @service.read_response('/remote/path')
    end
    
    it "returns the contents of the downloaded response" do
      @service.read_response('/remote/path').should == "response"
    end
    
    it "polls until response shows up" do
      error = Net::FTPPermError.new("No such file")
      # Raise error on the first two calls...
      @ftp.expects(:gettextfile).times(3).raises(error).then.raises(error).then.returns(nil)
      lambda {
        @service.read_response('/remote/path')
      }.should_not raise_error
    end
    
    it "times out if response takes longer than 2 minutes to show up" do
      # TODO: Less brittle way to test this?
      # Currently depends on inner workings of Timeout.
      Timeout.expects(:sleep).with(120)
      lambda {
        @service.read_response('/remote/path')
      }.should raise_error(Timeout::Error)
    end

    it "doesn't gobble up every FTP exception" do
      @ftp.stubs(:gettextfile).raises(Net::FTPPermError.new("Permission denied")).then.returns(nil)
      lambda {
        @service.read_response('/remote/path')
      }.should raise_error(Net::FTPPermError, "Permission denied")
    end
  end
  
  describe '#close' do
    it 'closes the connection to the ftp server' do
      @ftp.expects(:close)
      FtpService.new('host', 'user', 'pass').close
    end
  end
end
