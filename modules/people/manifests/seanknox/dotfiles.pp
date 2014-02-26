class people::seanknox::dotfiles {

  file { "/Users/${::boxen_user}/.gitconfig":
    target  => "/Users/${::boxen_user}/dotfiles/gitconfig",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.bash_profile":
    target  => "/Users/${::boxen_user}/dotfiles/bash_profile",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.zlogin":
    target  => "/Users/${::boxen_user}/dotfiles/zlogin",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.zpreztorc":
    target  => "/Users/${::boxen_user}/dotfiles/zpreztorc",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.zshenv":
    target  => "/Users/${::boxen_user}/dotfiles/zshenv",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.zshrc":
    target  => "/Users/${::boxen_user}/dotfiles/zshrc",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.pryrc":
    target  => "/Users/${::boxen_user}/dotfiles/pryrc",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.powconfig":
    target  => "/Users/${::boxen_user}/dotfiles/powconfig",
    require => Repository["/Users/${::boxen_user}/dotfiles"]
  }

  file { "/Users/${::boxen_user}/.ssh":
    ensure => directory,
  }

}

