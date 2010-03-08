require 'tempfile'

module TempfileHelper
  extend self
  
  def read(name = nil)
    tempfile = nil
    name ||= Time.now.to_f
    Tempfile.open(name) { |tempfile| yield(tempfile) }
    File.read(tempfile.path)
  end
  
  def write(content, name = nil)
    name ||= Time.now.to_f.to_s
    file = Tempfile.new(name)
    file.write(content)
    file.close
    file
  end
end