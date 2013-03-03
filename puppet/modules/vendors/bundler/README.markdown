puppet-bundler
==============

Automatically install ruby dependencies

Examples
--------

    bundler::install { $app_root:
      user       => $app_user,
      group      => $app_group,
      deployment => true,
      without    => 'development test doc',
    }
