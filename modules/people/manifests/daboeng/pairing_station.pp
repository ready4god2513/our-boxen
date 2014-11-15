class people::daboeng::pairing_station {
  include people::daboeng::sublime

  file { "/Users/${::boxen_user}/.profile":
    content => template('people/daboeng/pairing_shell/.profile.erb'),
    replace => 'yes'
  }

  file { "/Users/${::boxen_user}/git-completion.bash":
    content => template('people/daboeng/pairing_shell/git-completion.bash.erb'),
    replace => 'yes'
  }
}
