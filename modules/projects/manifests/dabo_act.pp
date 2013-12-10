class projects::dabo_act {
  include phantomjs::1_9_0

  boxen::project { 'dabo_act':
    redis         => true,
    postgresql    => true,
    ruby          => '1.9.3-p484',
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

}
