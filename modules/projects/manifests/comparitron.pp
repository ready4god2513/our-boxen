class projects::comparitron {
  include heroku

  require postgresql

  $dabo_ruby_version = '2.1.5'

  boxen::project { 'comparitron':
    postgresql    => true,
    ruby          => $dabo_ruby_version,
    nginx         => true,
    source        => 'dabohealth/comparitron'
  }

  file { "${boxen::config::srcdir}/comparitron/config/database.yml":
      content => template('projects/comparitron/database.yml.erb'),
      require => Repository["${boxen::config::srcdir}/comparitron"],
      replace => 'yes'
  }

  file { "${boxen::config::srcdir}/comparitron/.env":
      content => template('projects/comparitron/env.erb'),
      require => Repository["${boxen::config::srcdir}/comparitron"],
      replace => 'no'
  }


  ## rbenv-installed gems cannot be run in the boxen installation environment
  ## which uses the system ruby. The environment must be cleared (env -i)
  ## so an installed ruby (and gems) can be used in a new shell.

  $bundle = "env -i zsh -c 'source /opt/boxen/env.sh && RBENV_VERSION=${dabo_ruby_version} bundle"

  ## NOTE: don't forget the trailing single quote in the command!
  ## e.g.
  ## command => "${bundle} install'"

  ## bundle install
  exec { 'bundle install comparitron':
    provider  => 'shell',
    command   => "${bundle} install'",
    cwd       => "${boxen::config::srcdir}/comparitron",
    require   => [
      Ruby[$dabo_ruby_version],
      Ruby_Gem["bundler for all rubies"],
      Service['postgresql']
    ],
    unless    => "${bundle} check'",
    timeout   => 1800
  }

  ## rake db:setup
  exec { 'rake db:setup comparitron':
    provider  => 'shell',
    command   => "${bundle} exec rake db:setup'",
    cwd       => "${boxen::config::srcdir}/comparitron",
    require   => [
      Exec['bundle install comparitron']
    ]
  }

  ## ensure pg_stat_statements is loaded (needed for Heroku DB dumps)
  exec { 'psql CREATE EXTENSION pg_stat_statements comparitron':
    provider  => 'shell',
    command   => "psql -p${postgresql::port} comparitron_development -c 'CREATE EXTENSION pg_stat_statements;'",
    require   => [
      Postgresql::Db['comparitron_development']
    ],
    unless    => ["psql -p${postgresql::port} comparitron_development -c '\\dx' | cut -d \\| -f1 | grep -w pg_stat_statements"]
  }

  exec { 'pre-commit install comparitron':
    provider      => 'shell',
    command   => "${bundle} exec pre-commit install'",
    cwd             => "${boxen::config::srcdir}/comparitron",
    require => [
      Exec['bundle install comparitron']
    ]
  }
}
