node default {

  $max_update_threshold = 640800

  class { 'apt':
    always_apt_update => true
  } -> Package <| |>

  class { 'votocomovamos::db': } -> class { 'votocomovamos::app': } -> class { 'votocomovamos::sidekiq': }

}
