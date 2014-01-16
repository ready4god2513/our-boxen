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

  ## rbenv-installed gems cannot be run in the boxen installation environment
  ## which uses the system ruby. The environment must be cleared (env -i)
  ## so an installed ruby (and gems) can be used in a new shell.

  $bundle = "env -i zsh -c 'source /opt/boxen/env.sh && RBENV_VERSION=${dabo_ruby_version} bundle"

  ## NOTE: don't forget the trailing single quote in the command!
  ## bundle install
  exec { "bundle install dabo_act":
    provider => 'shell',
    command => "${bundle} install'",
    cwd => "${boxen::config::srcdir}/dabo_act",
    require => [
      Ruby::Gem["bundler for ${dabo_ruby_version}"],
      Service['postgresql']
    ],
    unless => "${bundle} check'",
    timeout => 1800
  }

  ## rake db:migrate
  exec { "rake db:migrate dabo_act":
    provider => 'shell',
    command => "${bundle} exec rake db:migrate'",
    cwd => "${boxen::config::srcdir}/dabo_act",
    require => [
      Exec["bundle install dabo_act"],
      Postgresql::Db['dabo_act_development']
    ]
  }

  ## rake db:test:prepare
  exec { "rake db:test:prepare dabo_act":
    provider => 'shell',
    command => "${bundle} exec rake db:test:prepare'",
    cwd => "${boxen::config::srcdir}/dabo_act",
    require => [
      Exec["bundle install dabo_act"],
      Exec["rake db:migrate dabo_act"],
      Postgresql::Db['dabo_act_development']
    ]
  }

}
