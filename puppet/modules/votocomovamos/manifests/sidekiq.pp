class votocomovamos::sidekiq(
  $app_root = '/vcv2',
  $user = 'vcv2',
) {

  file {
    '/etc/init.d/sidekiq':
      ensure  => 'file',
      mode    => '0700',
      require => Class['votocomovamos::app'],
      content => template('votocomovamos/sidekiq.init.sh.erb'),
      owner   => 'root',
      group   => 'root',
    ;
  }

  service {
    'sidekiq':
      ensure  => 'running',
      enable  => 'true',
      require => File['/etc/init.d/sidekiq'],
    ;
  }
}
