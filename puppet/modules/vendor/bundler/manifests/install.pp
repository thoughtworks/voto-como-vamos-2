# = Define: bundler::install
#
# Perform a bundle install in a given directory. Wraps all of the
# fiddly little configuration guts.
#
# == Example
#
#  # Deploy a sinatra app
#  sinatra::app { 'appy':
#    giturl   => 'git://your.git.server/your/git/remote',
#  }
#
#  # And then run bundler
#  bundler::install {'/opt/boardie':
#    require => Sinatra::App['boardie'],
#  }
#
define bundler::install(
  $user         = 'root',
  $group        = 'root',
  $deployment   = false,
  $without      = undef,
  $gem_bin_path = undef,
  $ruby_version = undef,
  $real_user    = undef,
) {

  include bundler

  if $without { $without_real = " --without ${without}" }
  else        { $without_real = '' }

  $command = $deployment ? {
    true  => "bundle install --verbose --deployment${without_real}",
    false => "bundle install --verbose ${without_real}",
  }

  exec { "bundle install ${name}":
    user        => $user,
    group       => $group,
    command     => $command,
    cwd         => $name,
    path        => "${gem_bin_path}:/bin:/usr/bin:/usr/local/bin",
    unless      => 'bundle check',
    require     => Rbenv::Gem["rbenv::bundler ${real_user} ${ruby_version}"],
    logoutput   => on_failure,
    environment => "HOME='${name}'",
  }
}
