define postgresql::extension($extension, $db = $title) {

  include postgresql::params

  postgresql_psql {
    "add extension ${extension} to ${db}":
      command   => "CREATE EXTENSION ${extension}",
      unless    => "SELECT extname FROM pg_extension WHERE extname='${extension}'",
      require   => Postgresql::Db[$db],
      psql_user => 'postgres',
      db        => $db,
      cwd       => $postgresql::params::datadir,
    ;
  }

}
