class people::seanknox::vim {

  $home = $people::seanknox::home
  $dotfiles = $people::seanknox::dotfiles

  repository { "${boxen::config::srcdir}/maximum-awesome":
    source  => 'square/maximum-awesome'
  }

  # Manage dotfiles with Boxen
  file { "${home}/.gvimrc":
    target  => "${dotfiles}/gvimrc",
    require => Repository["$dotfiles"]
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
