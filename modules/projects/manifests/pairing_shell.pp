class projects::pairing_shell {
  file { "/Users/${::boxen_user}/.profile":
    content => template('projects/pairing_shell/.profile.erb'),
    replace => 'yes'
  }

  file { "/Users/${::boxen_user}/git-completion.bash":
    content => template('projects/pairing_shell/git-completion.bash.erb'),
    replace => 'yes'
  }
}
