stage {
  'bootstrap':
    before => Stage['main']
  ;
}

node default {

  class {
    'apt':
      stage             => 'bootstrap',
      always_apt_update => false,
    ;
  }

  include redis
  include postgresql::server
  include postgresql::client
  include postgresql::devel

  postgresql::db {

    'vcv_production':
      user     => 'vcv',
      password => 'vcv',
      charset  => 'UTF-8',
    ;

    'vcv_test':
      user     => 'vcv',
      password => 'vcv',
      charset  => 'UTF-8',
    ;

    'vcv_development':
      user     => 'vcv',
      password => 'vcv',
      charset  => 'UTF-8',
    ;

 }

  rbenv::install {
    'vagrant':
      home => '/home/vagrant'
    ;
  }

  rbenv::compile {
    '1.9.3-p385':
      user   => 'vagrant',
      home   => '/home/vagrant',
      global => true,
    ;
  }

  $passenger_version = '3.0.19'
  $gem_path = '/opt/vagrant_ruby/lib/ruby/gems/1.8/gems'
  $gem_bin_path = '/opt/vagrant_ruby/bin'

  class {
    'apache':

    ;

    'passenger':
      require                => Rbenv::Compile['1.9.3-p385'],
      passenger_package      => 'passenger',
      passenger_version      => $passenger_version,
      passenger_ruby         => '/home/vagrant/.rbenv/shims/ruby',
      gem_path               => $gem_path,
      gem_binary_path        => $gem_bin_path,
      mod_passenger_location => "${gem_path}/passenger-${passenger_version}/ext/apache2/mod_passenger.so",
    ;
  }

  apache::vhost {
    'vcv':
      vhost_name    => '*',
      port          => '80',
      template      => 'apache/vhost-passenger.conf.erb',
      serveradmin   => 'vcv@lixo.org',
      docroot       => '/vagrant/public',
      docroot_owner => 'vagrant',
      docroot_group => 'vagrant',
    ;
  }

  bundler::install {
    '/vagrant':
      gem_bin_path => $gem_bin_path,
    ;
  }
}
