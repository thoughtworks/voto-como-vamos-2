stage {
  'bootstrap':
    before => Stage['main']
  ;
}

node default {

  class {
    'apt':
      stage             => 'bootstrap',
      always_apt_update => true,
    ;
  }

  include postgresql::server
  include postgresql::client
  include postgresql::devel

  postgresql::db {
    'vcv':
      user     => 'vcv',
      password => 'vcv',
      charset  => 'UTF-8',
    ;
  }

  include redis
}
