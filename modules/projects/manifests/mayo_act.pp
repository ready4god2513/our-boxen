class projects::mayo_act {
  include heroku
  include virtualbox

  require postgresql
  require phantomjs

  package { [
    'chromedriver'
    ]:
      ensure => latest,
  }

  $dabo_ruby_version = '2.1.5'

  boxen::project { 'mayo_act':
    redis         => true,
    postgresql    => true,
    ruby          => $dabo_ruby_version,
    nginx         => true,
    source        => 'dabohealth/mayo_act'
  }

  file { "${boxen::config::srcdir}/mayo_act/config/database.yml":
      content => template('projects/mayo_act/database.yml.erb'),
      require => Repository["${boxen::config::srcdir}/mayo_act"],
      replace => 'no'
  }

  file { "${boxen::config::srcdir}/mayo_act/.env":
      content => template('projects/mayo_act/env.erb'),
      require => Repository["${boxen::config::srcdir}/mayo_act"],
      replace => 'no'
  }

  boxen::env_script { 'redistogo':
    ensure   => $ensure,
    content  => template('projects/mayo_act/redistogo.sh.erb'),
    priority => 'lowest',
  }

  ## rbenv-installed gems cannot be run in the boxen installation environment
  ## which uses the system ruby. The environment must be cleared (env -i)
  ## so an installed ruby (and gems) can be used in a new shell.

  $bundle = "env -i zsh -c 'source /opt/boxen/env.sh && REDISTOGO_URL=redis://localhost:16379 RBENV_VERSION=${dabo_ruby_version} bundle"

  ## NOTE: don't forget the trailing single quote in the command!
  ## e.g.
  ## command => "${bundle} install'"

  ## bundle install
  exec { 'bundle install mayo_act':
    provider  => 'shell',
    command   => "${bundle} install'",
    cwd       => "${boxen::config::srcdir}/mayo_act",
    require   => [
      Ruby[$dabo_ruby_version],
      Ruby_Gem["bundler for all rubies"],
      Service['postgresql']
    ],
    unless    => "${bundle} check'",
    timeout   => 1800
  }

  ## rake db:setup
  exec { 'rake db:setup mayo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake db:setup'",
    cwd       => "${boxen::config::srcdir}/mayo_act",
    require   => [
      Exec['bundle install mayo_act']
    ]
  }

  ## rake db:fixtures:load
  exec { 'rake db:fixtures:load mayo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake db:fixtures:load'",
    cwd       => "${boxen::config::srcdir}/mayo_act",
    require   => [
      Exec['rake db:setup mayo_act'],
      Postgresql::Db['mayo_act_development']
    ]
  }

  ## rake parallel:create
  exec { 'rake parallel:create mayo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake parallel:create'",
    cwd       => "${boxen::config::srcdir}/mayo_act",
    require   => [
      Exec['rake db:setup mayo_act']
    ]
  }

  ## rake parallel:prepare
  exec { 'rake parallel:prepare mayo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake parallel:prepare'",
    cwd       => "${boxen::config::srcdir}/mayo_act",
    require   => [
      Exec['rake parallel:create mayo_act']
    ]
  }

  ## rake secret > .env
  exec { 'rake secret mayo_act':
    provider  => 'shell',
    command   => "echo DABO_RAILS_SECRET_KEY_BASE=`${bundle} exec rake secret'` >> .env",
    cwd       => "${boxen::config::srcdir}/mayo_act",
    require   => [
      File["${boxen::config::srcdir}/mayo_act/.env"],
      Exec['rake db:setup mayo_act']
    ],
    unless    => ['grep DABO_RAILS_SECRET_KEY_BASE .env']
  }

  ## ensure pg_stat_statements is loaded (needed for Heroku DB dumps)
  exec { 'psql CREATE EXTENSION pg_stat_statements':
    provider  => 'shell',
    command   => "psql -p${postgresql::port} mayo_act_development -c 'CREATE EXTENSION pg_stat_statements;'",
    require   => [
      Postgresql::Db['mayo_act_development']
    ],
    unless    => ["psql -p${postgresql::port} mayo_act_development -c '\\dx' | cut -d \\| -f1 | grep -w pg_stat_statements"]
  }

  ## Mailcatcher gem needs to be installed outside of bundler
  ruby_gem { "mailcatcher for $dabo_ruby_version":
    gem       => 'mailcatcher',
    ruby_version      => $dabo_ruby_version,
    require   => Ruby_Gem["bundler for all rubies"],
  }

  exec { 'pre-commit install mayo_act':
    provider      => 'shell',
    command   => "${bundle} exec pre-commit install'",
    cwd             => "${boxen::config::srcdir}/mayo_act",
    require => [
      Exec['bundle install mayo_act']
    ]
  }
}