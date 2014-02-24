class people::seanknox {


  include people::seanknox::dotfiles
  include people::seanknox::applications
  ##include people::seanknox::config
  #include people::seanknox::sublime

  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source  => 'seanknox/dotfiles'
  }
  repository { "/Users/${::boxen_user}/.zprezto":
    source  => 'seanknox/prezto'
  }

}

