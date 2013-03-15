class votocomovamos::app(
  $user  = 'vcv2',
  $group = 'vcv2'
) {

  $ruby_version = '1.9.3-p392'

  user {
    $user:
      home       => '/home/vcv2',
      ensure     => 'present',
      managehome => true,
      comment    => 'vcv2 daemon user',
    ;
  }

  rbenv::install {
    $user:
      home    => "/home/${user}",
      require => User[$user],
    ;
  }

  rbenv::compile {
    $ruby_version:
      user   => $user,
      home   => "/home/${user}",
      global => true,
    ;
  }
  Rbenv::Gem["rbenv::bundler ${user} ${ruby_version}"] -> Exec["rbenv::rehash ${user} ${ruby_version}"]

  $passenger_version = '3.0.19'
  $gem_path = "/home/${user}/.rbenv/versions/${ruby_version}/lib/ruby/gems/1.9.1/gems"

  rbenv::gem { 'passenger': user => $user, ruby => $ruby_version } -> Exec["rbenv::rehash ${user} ${ruby_version}"] -> Class['passenger']

  class {
    'apache':
    ;

    'passenger':
      passenger_package      => 'passenger',
      passenger_version      => $passenger_version,
      passenger_ruby         => "/home/${user}/.rbenv/versions/${ruby_version}/bin/ruby",
      gem_path               => $gem_path,
      gem_binary_path        => "/home/${user}/.rbenv/versions/${ruby_version}/bin",
      mod_passenger_location => "${gem_path}/passenger-${passenger_version}/ext/apache2/mod_passenger.so",
      require                => Bundler::Install['/vcv2'],
    ;
  }

  Class['passenger'] -> Service['httpd']

  apache::vhost {
    'vcv':
      vhost_name    => '*',
      port          => '80',
      template      => 'apache/vhost-passenger.conf.erb',
      serveradmin   => "${user}@lixo.org",
      docroot       => '/vcv2/public',
      docroot_owner => $user,
      docroot_group => $group,
    ;
  }

  bundler::install {
    '/vcv2':
      gem_bin_path => "/home/${user}/.rbenv/shims",
      user         => $user,
      group        => $group,
      require      => Rbenv::Gem["rbenv::bundler ${user} ${ruby_version}"],
      ruby_version => $ruby_version,
      real_user    => $user,
    ;
  }

}
