class projects::dabo_act {
  include phantomjs::1_9_0

  $dabo_ruby_version = "2.0.0-p353"

  boxen::project { 'dabo_act':
    redis         => true,
    postgresql    => true,
    ruby          => $dabo_ruby_version,
    phantomjs     => '1.9.0',
    source        => 'dabohealth/dabo_act'
  }

  file { "${boxen::config::srcdir}/dabo_act/config/database.yml":
      content => template("/opt/boxen/repo/modules/projects/templates/dabo_act/database.yml.erb"),
      require => Repository["${boxen::config::srcdir}/dabo_act"]
  }

  file { "${boxen::config::srcdir}/dabo_act/.env":
      content => template("/opt/boxen/repo/modules/projects/templates/dabo_act/env.erb"),
      require => Repository["${boxen::config::srcdir}/dabo_act"]
  }

  # Run bundle install.
  # rbenv-installed gems cannot be run in the boxen installation environment which uses the system
  # ruby. The environment must be cleared (env -i) so an installed ruby (and gems) can be used in a new shell.
  exec { "env -i bash -c 'source /opt/boxen/env.sh && RBENV_VERSION=${dabo_ruby_version} bundle install'":
    provider => 'shell',
    cwd => "${boxen::config::srcdir}/dabo_act",
    require => [ Ruby::Gem["bundler for ${dabo_ruby_version}"] ]
  }

}
