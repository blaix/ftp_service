require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tempfile_helper'

describe "TempfileHelper" do
  describe '.read([name]) { |tempfile| }' do
    before do
      @tempfile = nil
      TempfileHelper.read { |@tempfile| }
    end
    
    it "yields a Tempfile object" do
      @tempfile.should be_a(Tempfile)
    end
    
    it "closes the tempfile object after the block executes" do
      @tempfile.should be_closed
    end
    
    it "closes the tempfile object even if an exception is raised" do
      tempfile = nil
      lambda {
        TempfileHelper.read { |tempfile| raise "boom" }
      }.should raise_error
      tempfile.should be_closed
    end
    
    it "accepts an optional name for the tempfile" do
      tempfile = nil
      TempfileHelper.read('the_name') { |tempfile| }
      tempfile.path.should include('the_name')
    end
    
    it "returns contents of the tempfile after the block is executed" do
      TempfileHelper.read do |tempfile|
        tempfile.write('the contents')
      end.should == 'the contents'
    end
  end
  
  describe '.write_temp_file(content[, name])' do
    before do
      @tempfile = TempfileHelper.write('the content')
    end
    
    it "returns a tempfile object" do
      @tempfile.should be_a(Tempfile)
    end
    
    it "writes the passed content to the temp file" do
      File.read(@tempfile.path).should == 'the content'
    end
    
    it "closes the tempfile object" do
      @tempfile.should be_closed
    end

    it "accepts an optional name for the temp file" do
      tempfile = TempfileHelper.write('the content', 'the_name')
      tempfile.path.should include('the_name')
    end
  end
end