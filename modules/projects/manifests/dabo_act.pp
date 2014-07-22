class projects::dabo_act {
  include heroku
  include virtualbox

  require postgresql

  package { [
    'chromedriver'
    ]:
      ensure => latest,
  }

  $dabo_ruby_version = '2.0.0-p353'
  class {'phantomjs':
    phantomenv_repository => 'dabohealth/phantomenv',
    phantomenv_version    => 'v0.0.9'
  }

  boxen::project { 'dabo_act':
    redis         => true,
    postgresql    => true,
    ruby          => $dabo_ruby_version,
    phantomjs     => '1.9.7',
    nginx         => true,
    source        => 'dabohealth/dabo_act'
  }

  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.0',
    ruby_version => '*',
  }

  file { "${boxen::config::srcdir}/dabo_act/config/database.yml":
      content => template('projects/dabo_act/database.yml.erb'),
      require => Repository["${boxen::config::srcdir}/dabo_act"],
      replace => 'no'
  }

  file { "${boxen::config::srcdir}/dabo_act/.env":
      content => template('projects/dabo_act/env.erb'),
      require => Repository["${boxen::config::srcdir}/dabo_act"],
      replace => 'no'
  }

  boxen::env_script { 'redistogo':
    ensure   => $ensure,
    content  => template('projects/dabo_act/redistogo.sh.erb'),
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
  exec { 'bundle install dabo_act':
    provider  => 'shell',
    command   => "${bundle} install'",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      Ruby_Gem["bundler for all rubies"],
      Service['postgresql']
    ],
    unless    => "${bundle} check'",
    timeout   => 1800
  }

  ## rake db:setup
  exec { 'rake db:setup dabo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake db:setup'",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      Exec['bundle install dabo_act']
    ]
  }

  ## rake db:sample_data
  exec { 'rake db:sample_data dabo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake db:sample_data'",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      Exec['rake db:setup dabo_act'],
      Postgresql::Db['dabo_act_development']
    ]
  }

  ## rake db:fixtures:load
  exec { 'rake db:fixtures:load dabo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake db:fixtures:load'",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      Exec['rake db:sample_data dabo_act'],
      Postgresql::Db['dabo_act_development']
    ]
  }

  ## rake parallel:create
  exec { 'rake parallel:create dabo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake parallel:create'",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      Exec['rake db:setup dabo_act']
    ]
  }

  ## rake parallel:prepare
  exec { 'rake parallel:prepare dabo_act':
    provider  => 'shell',
    command   => "${bundle} exec rake parallel:prepare'",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      Exec['rake parallel:create dabo_act']
    ]
  }

  ## rake secret > .env
  exec { 'rake secret dabo_act':
    provider  => 'shell',
    command   => "echo DABO_RAILS_SECRET_KEY_BASE=`${bundle} exec rake secret'` >> .env",
    cwd       => "${boxen::config::srcdir}/dabo_act",
    require   => [
      File["${boxen::config::srcdir}/dabo_act/.env"],
      Exec['rake db:setup dabo_act']
    ],
    unless    => ['grep DABO_RAILS_SECRET_KEY_BASE .env']
  }

  ## ensure pg_stat_statements is loaded (needed for Heroku DB dumps)
  exec { 'psql CREATE EXTENSION pg_stat_statements':
    provider  => 'shell',
    command   => "psql -p${postgresql::port} dabo_act_development -c 'CREATE EXTENSION pg_stat_statements;'",
    require   => [
      Postgresql::Db['dabo_act_development']
    ],
    unless    => ["psql -p${postgresql::port} dabo_act_development -c '\\dx' | cut -d \\| -f1 | grep -w pg_stat_statements"]
  }

  ## Mailcatcher gem needs to be installed outside of bundler
  ruby_gem { "mailcatcher for $dabo_ruby_version":
    gem       => 'mailcatcher',
    ruby_version      => $dabo_ruby_version,
    require   => Ruby_Gem["bundler for all rubies"],
  }
}
