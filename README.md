INSTALL
=======

* Install ruby, rubygems. 
* gem install bundler
* bundle install
* set your server settings in web.rb
* rackup

KNOWN BUG
=========

ELF32 issue with 64bits OS. Just change the link to the correct lib.
It should be /usr/lib/libmqic_r.so -> /opt/mqm/lib64/libmqic_r.so
