node default {

  $max_update_threshold = 640800

  exec {
    'apt-get update':
      command => '/usr/bin/apt-get update',
      onlyif  => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= ${max_update_threshold} ))'",
    ;
  }

  Exec['apt-get update'] -> Package <| |>

  class{ 'votocomovamos::db': } -> class { 'votocomovamos::app': }
  include votocomovamos::sidekiq

}
