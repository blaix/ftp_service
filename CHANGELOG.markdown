# v0.3.0 (2010-03-18)

* `FtpService#write_request` and `FtpService#read_response` support
  encryption/decryption with gpg.
* `FtpService#write_request` uses an intermediate temp file while
  uploading to avoid case where server might try and respond to an
  in-progress upload of a large request.
* `FtpService#read_response` polls for a response.

# v0.2.0 (2010-03-08)

* Add `FtpService#write_request` and `FtpService#read_response` methods,
  making this thing actually usable.
* Switch to Markdown + Yardoc for rdocs.

# v0.1.1 (2010-03-08)

* First version. Opens a connection but that's it. Useful, huh?