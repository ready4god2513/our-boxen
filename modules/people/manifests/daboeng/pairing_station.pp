class people::daboeng::pairing_station {

  include flux::beta

  file { "/Users/${::boxen_user}/.profile":
    content => template('people/daboeng/pairing_shell/.profile.erb'),
    replace => 'yes'
  }

  file { "/Users/${::boxen_user}/git-completion.bash":
    content => template('people/daboeng/pairing_shell/git-completion.bash.erb'),
    replace => 'yes'
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
