class people::seanknox::dotfiles {

  $home = $people::seanknox::home
  $dotfiles = $people::seanknox::dotfiles

  file { "${home}/.gitconfig":
    target  => "${dotfiles}/gitconfig",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.bash_profile":
    target  => "${dotfiles}/bash_profile",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.zlogin":
    target  => "${dotfiles}/zlogin",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.zpreztorc":
    target  => "${dotfiles}/zpreztorc",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.zshenv":
    target  => "${dotfiles}/zshenv",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.zshrc":
    target  => "${dotfiles}/zshrc",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.pryrc":
    target  => "${dotfiles}/pryrc",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.powconfig":
    target  => "${dotfiles}/powconfig",
    require => Repository["$dotfiles"]
  }

  file { "${home}/.ssh":
    ensure => directory,
  }

}
