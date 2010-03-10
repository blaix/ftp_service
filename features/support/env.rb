$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'ftp_service'

RubyGpg.config.homedir = File.dirname(__FILE__) + '/../../test_keys'

TMP_PATH = File.dirname(__FILE__) + '/../../tmp'
