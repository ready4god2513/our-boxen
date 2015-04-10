class projects::iris {
  include heroku

  require postgresql

  $dabo_ruby_version = '2.2.1'
  $dabo_node_version = 'v0.12.0'

  boxen::project { 'iris':
    redis         => true,
    postgresql    => true,
    ruby          => $dabo_ruby_version,
    nginx         => true,
    nodejs        => $dabo_node_version,
    source        => 'seanknox/iris'
  }

  file { "${boxen::config::srcdir}/iris/.env":
      content => template('projects/iris/env.erb'),
      require => Repository["${boxen::config::srcdir}/iris"],
      replace => 'no'
  }

  boxen::env_script { 'redis_provider':
    ensure   => $ensure,
    content  => template('projects/iris/redis_provider.sh.erb'),
    priority => 'lowest',
  }


  ## rbenv-installed gems cannot be run in the boxen installation environment
  ## which uses the system ruby. The environment must be cleared (env -i)
  ## so an installed ruby (and gems) can be used in a new shell.
  ## env -i also clears out SHELL, so it must be defined when running commands.

  $base_environment = "env -i SHELL=/bin/bash /bin/bash -c 'source /opt/boxen/env.sh &&"
  $bundle = "$base_environment RBENV_VERSION=${dabo_ruby_version} bundle"

  ## NOTE: don't forget the trailing single quote in the command!
  ## e.g.
  ## command => "${bundle} install'"

  ## bundle install
  exec { 'bundle install iris':
    provider  => 'shell',
    command   => "${bundle} install'",
    cwd       => "${boxen::config::srcdir}/iris",
    require   => [
      Ruby[$dabo_ruby_version],
      Ruby_Gem["bundler for all rubies"],
      Service['postgresql']
    ],
    unless    => "${bundle} check'",
    timeout   => 1800
  }

  ## rake db:setup
  exec { 'rake db:setup iris':
    provider  => 'shell',
    command   => "${bundle} exec rake db:setup'",
    cwd       => "${boxen::config::srcdir}/iris",
    require   => [
      Exec['bundle install iris']
    ]
  }

  exec { 'overcommit install iris':
    provider  => 'shell',
    command   => "${bundle} exec overcommit --install --force && rm .git/hooks/post-checkout .git/hooks/commit-msg'",
    cwd       => "${boxen::config::srcdir}/iris",
    require   => [
      Exec['bundle install iris'],
      Exec['npm install']
    ]
  }

  exec { 'npm install':
    provider => 'shell',
    command  => "$base_environment npm install'",
    cwd      => "${boxen::config::srcdir}/iris",
    require  => Nodejs[$dabo_node_version]
  }
}
