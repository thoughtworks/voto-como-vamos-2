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

  include redis
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

  $gem_bin_path = '/opt/vagrant_ruby/bin'

  class {
    'apache':

    ;

    'passenger':
      require                => Rbenv::Compile['1.9.3-p385'],
      passenger_package      => 'passenger',
      passenger_version      => '3.0.19',
      passenger_ruby         => '/home/vagrant/.rbenv/shims/ruby',
      gem_path               => '/opt/vagrant_ruby/lib/ruby/gems/1.8/gems',
      gem_binary_path        => $gem_bin_path,
    ;
  }

  apache::vhost {
    'vcv':
      vhost_name  => '*',
      port        => '80',
      template    => 'apache/vhost-passenger.conf.erb',
      serveradmin => 'vcv@lixo.org',
      docroot     => '/vagrant/public',
    ;
  }

  bundler::install {
    '/vagrant':
      user         => 'vagrant',
      group        => 'vagrant',
      gem_bin_path => $gem_bin_path,
    ;
  }

}
