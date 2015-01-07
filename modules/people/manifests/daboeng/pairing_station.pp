class people::daboeng::pairing_station {

  include flux::beta

  file { "/Users/${::boxen_user}/.profile":
    content => template('people/daboeng/pairing_shell/.profile.erb'),
    replace => 'yes'
  }

  file { "/Users/${::boxen_user}/git-completion.bash":
    content   => template('people/daboeng/pairing_shell/git-completion.bash.erb'),
    replace   => 'yes'
  }

  file { "${boxen::config::home}/bin/clear_chrome":
    source    => "puppet:///${boxen::config::home}/repo/manifests/files/clear_chrome",
    replace   => 'yes'
  }

  file { '/Library/LaunchDaemons/dev.clearchrome.plist':
    source    => "puppet:///${boxen::config::home}/repo/manifests/files/dev.clearchrome.plist",
    group     => 'wheel',
    owner     => 'root',
    notify    => Service['dev.clearchrome']
  }

  exec { "Wake computer at 3 a.m. to run clearchrome daemon":
    command => "pmset repeat wakeorpoweron MTWRF 3:00:00",
    user    => root
  }

  service { 'dev.clearchrome':
    ensure    => running
  }

  osx_login_item {
    'iTerm':
      name    => 'iTerm',
      path    => '/Applications/iTerm.app',
      hidden  => false;
  }

  osx_login_item {
    'Alfred 2':
      name    => 'Alfred 2',
      path    => '/Applications/Alfred 2.app',
      hidden  => true;
  }
}
