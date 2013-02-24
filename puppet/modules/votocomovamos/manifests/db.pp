class votocomovamos::db {

  include redis

  include postgresql::server
  include postgresql::client
  include postgresql::devel

  package {
    'postgresql-contrib':
      ensure  => 'installed',
    ;
  }

  postgresql::extension {

    'vcv_development':
      extension => 'hstore',
      require   => Package['postgresql-contrib'],
    ;

    'vcv_test':
      extension => 'hstore',
      require   => Package['postgresql-contrib'],
    ;

    'vcv_production':
      extension => 'hstore',
      require   => Package['postgresql-contrib'],
    ;

  }

  postgresql::db {

    'vcv_production':
      user      => 'vcv',
      password  => 'vcv',
      charset   => 'UTF-8',
    ;

    'vcv_test':
      user      => 'vcv',
      password  => 'vcv',
      charset   => 'UTF-8',
    ;

    'vcv_development':
      user      => 'vcv',
      password  => 'vcv',
      charset   => 'UTF-8',
    ;

  }

}
