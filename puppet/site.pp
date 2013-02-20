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

  include nginx

  nginx::resource::upstream {
    'vcv':
      ensure  => 'present',
      members => [
        'localhost:3000',
      ],
    ;
  }

  nginx::resource::vhost {
    'dev.votocomovamos.com.br':
      ensure      => 'present',
      proxy       => 'http://vcv',
      listen_port => 80,
    ;
  }

  include redis
}
