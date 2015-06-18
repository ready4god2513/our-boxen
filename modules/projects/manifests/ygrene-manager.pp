class projects::ygrene-manager {
  require mysql

  $ygrene_ruby_version = '2.1.5'
  $ygrene_node_version = 'v0.10.28'
  $pdftk_version = '1.44'

  boxen::project { 'ygrene-manager':
    redis         => true,
    mysql         => true,
    ruby          => $ygrene_ruby_version,
    nodejs        => $ygrene_node_version,
    nginx         => true,
    source        => 'ygrene/Ygrene-Energy-Fund',
    dir           => "${boxen::config::srcdir}/ygrene-manager"
  }

  package { 'PDFtk':
    provider => 'pkgdmg',
    source   => "https://flexpaper-desktop-publisher.googlecode.com/files/pdftk-${pdftk_version}-osx10.6.dmg",
  }

  package {
    [
      'imagemagick'
    ]:
  }

  package { 'phantomjs':
     provider => 'brewcask',
     install_options => "--binarydir=${boxen::config::homebrewdir}/bin"
  }

  repository { "${boxen::config::srcdir}/ygrene-manager/pdftk_files/templates":
    source  => 'ygrene/YgrenePDFTemplates'
  }

  ruby_gem { 'engineyard':
    gem          => 'engineyard',
    version      => '~> 3.1.3',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'chef':
    gem          => 'chef',
    version      => '~> 10.16.4',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'knife-solo_data_bag':
    gem          => 'knife-solo_data_bag',
    version      => '~> 1.1.0',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'bundler for ygrene-manager ruby':
    gem          => 'bundler',
    version      => '~> 1.10.3',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'highline':
    gem          => 'highline',
    version      => '~> 1.7.2',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'terminal-table':
    gem          => 'terminal-table',
    version      => '~> 1.4.5',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'colorize':
    gem          => 'colorize',
    version      => '~> 0.7.7',
    ruby_version => $ygrene_ruby_version,
  }

  ruby_gem { 'overcommit':
    gem          => 'overcommit',
    version      => '~> 0.26.0',
    ruby_version => $ygrene_ruby_version,
  }

  file { "${boxen::config::srcdir}/ygrene-manager/.env":
      content => template('projects/ygrene-manager/env'),
      require => Repository["${boxen::config::srcdir}/ygrene-manager"],
      replace => 'no'
  }

  file { "${boxen::config::srcdir}/ygrene-manager/config/database.yml":
      content => template('projects/ygrene-manager/database.yml.erb'),
      require => Repository["${boxen::config::srcdir}/ygrene-manager"],
      replace => 'no'
  }

  ## rbenv-installed gems cannot be run in the boxen installation environment
  ## which uses the system ruby. The environment must be cleared (env -i)
  ## so an installed ruby (and gems) can be used in a new shell.
  ## env -i also clears out SHELL, so it must be defined when running commands.

  $base_environment = "env -i SHELL=/bin/bash /bin/bash -c 'source /opt/boxen/env.sh &&"
  $bundle = "$base_environment RBENV_VERSION=${ygrene_ruby_version} bundle"
  $bundle_test = "$base_environment RBENV_VERSION=${ygrene_ruby_version} RAILS_ENV=test bundle"

  ## NOTE: don't forget the trailing single quote in the command!
  ## e.g.
  ## command => "${bundle} install'"

  exec { 'bundle install ygrene':
    provider  => 'shell',
    command   => "${bundle} install --path vendor/bundle'",
    cwd       => "${boxen::config::srcdir}/ygrene-manager",
    require   => [
      Ruby[$ygrene_ruby_version],
      Ruby_Gem["bundler for all rubies"],
      Service['mysql']
    ],
    unless    => "${bundle} check'",
    timeout   => 1800
  }

  exec { 'rake db:setup ygrene':
    provider  => 'shell',
    command   => "${bundle} exec rake db:setup'",
    cwd       => "${boxen::config::srcdir}/ygrene-manager",
    require   => [
      Exec['bundle install ygrene'],
      File["${boxen::config::srcdir}/ygrene-manager/.env"],
      File["${boxen::config::srcdir}/ygrene-manager/config/database.yml"],
    ]
  }

  ## Create additional DBs for parallel_tests
  ## We use dotenv to manage credentials in test, but parallel_tests by default
  ## runs RAILS_ENV=development which screws up our carefully laid plans.
  ## Thus parallel_tests is only available from the test environment and the
  ## env must be explicitly set if using directly.
  exec { 'rake parallel:create':
    provider  => 'shell',
    command   => "${bundle_test} exec rake parallel:create'",
    cwd       => "${boxen::config::srcdir}/ygrene-manager",
    require   => [
      Exec['rake db:setup ygrene'],
      File["${boxen::config::srcdir}/ygrene-manager/.env"],
      File["${boxen::config::srcdir}/ygrene-manager/config/database.yml"],
    ]
  }

  ## Copy development DB schema to parallel DBs
  exec { 'rake parallel:load_schema':
    provider  => 'shell',
    command   => "${bundle_test} exec rake parallel:load_schema'",
    cwd       => "${boxen::config::srcdir}/ygrene-manager",
    require   => [
      Exec['rake parallel:create'],
      File["${boxen::config::srcdir}/ygrene-manager/.env"],
      File["${boxen::config::srcdir}/ygrene-manager/config/database.yml"],
    ]
  }

  exec { 'overcommit install ygrene':
    provider  => 'shell',
    command   => "${bundle} exec overcommit --install --force && rm .git/hooks/post-checkout .git/hooks/commit-msg'",
    cwd       => "${boxen::config::srcdir}/ygrene-manager",
    require   => [
      Exec['bundle install ygrene']
    ]
  }
}
