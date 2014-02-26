class people::seanknox::vim {

  repository { "${boxen::config::srcdir}/maximum-awesome":
    source  => 'square/maximum-awesome'
  }

  # Manage dotfiles with Boxen
  file { "${boxen::config::home}/.gvimrc":
    target  => "/Users/${boxen_user}/dotfiles/gvimrc",
    require => Repository["/Users/${boxen_user}/dotfiles"]
  }

  exec { 'install maximum-awesome':
    provider  => 'shell',
    command   => "env -i zsh -c 'source /opt/boxen/env.sh && rake'",
    cwd       => "${boxen::config::srcdir}/maximum-awesome",
    require   => [
      Repository["${boxen::config::srcdir}/maximum-awesome"]
    ],
    timeout   => 1800
  }

}
