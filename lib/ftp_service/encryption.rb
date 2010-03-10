begin
  require 'ruby_gpg'
rescue LoadError
  require 'rubygems'
  require 'ruby_gpg'
end

class FtpService
  module Encryption
    private
    # Expects a tempfile object and a string for the recipient.
    def encrypt(file, recipient)
      RubyGpg.encrypt(file.path, recipient)
      file.path << ".gpg"
    end
  end
end
