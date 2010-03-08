require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tempfile_helper'

describe "TempfileHelper" do
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