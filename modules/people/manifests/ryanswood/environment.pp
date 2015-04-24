class people::ryanswood::environment {
  file { "/Users/${::boxen_user}/.profile":
    content => template('people/ryanswood/environment/.profile.erb'),
    replace => 'yes'
  }

  file { "/Users/${::boxen_user}/.pryrc":
    content => template('people/ryanswood/environment/.pryrc.erb'),
    replace => 'yes'
  }

  file { "/Users/${::boxen_user}/git-completion.bash":
    content => template('people/ryanswood/environment/git-completion.bash.erb'),
    replace => 'yes'
  }
}
