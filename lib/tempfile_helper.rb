require 'tempfile'

module TempfileHelper
  extend self
  
  def write(content, name = nil)
    name ||= Time.now.to_f.to_s
    file = Tempfile.new(name)
    file.write(content)
    file.close
    file
  end
end