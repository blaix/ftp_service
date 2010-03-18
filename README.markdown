# FTP Service

An FTP Service is like a web service except stupid. You send your
request by uploading an xml file and get your response by downloading
another xml file. Have you ever had to deal with something like that? I
have. It sucks.

RDocs on [rdoc.info](http://rdoc.info/projects/blaix/ftp_service).

Source code on [github](http://github.com/blaix/ftp_service).

## Installation
  
    gem install ftp_service
    
## Usage

    require 'ftp_service'
  
    FtpService.open('host', 'user', 'pass') do |service|
      service.write_request('<foo>bar</foo>', "/request/path.xml")
      response = service.read_response("/response/path.xml")
    end

For more details, see the
[RDocs](http://rdoc.info/projects/blaix/ftp_service).
  
## Copyright

Copyright (c) 2010 Justin Blake. See
[LICENSE](http://github.com/blaix/ftp_service/raw/master/LICENSE) for
details.
