class people::seanknox {

  notify { 'Hi ${::boxen_user}!': }

  include people::seanknox::dotfiles
  include people::seanknox::applications
  ##include people::seanknox::config

  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source  => 'seanknox/dotfiles'
  }
  repository { "/Users/${::boxen_user}/.zprezto":
    source  => 'seanknox/prezto'
  }

}

