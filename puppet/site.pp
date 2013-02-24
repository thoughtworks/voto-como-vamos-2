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

  include votocomovamos::db
  include votocomovamos::app
}
