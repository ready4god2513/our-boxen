class people::seanknox::applications {

  include virtualbox
  include tmux
  include iterm2::stable
  include dropbox
  include kindle
  include macvim
  include gitx::dev
  include python
  include mysql
  include flux
  include alfred
  include transmission
  include zsh
  include onepassword
  include ctags
  include skitch
  include openssl
  include cmake
  include protobuf
  /* include vim */

  include sublime_text_2

  $sublime_package_dir = "/Users/${::boxen_user}/Library/Application Support/Sublime Text 2/Packages"

  file {
    [ "$sublime_package_dir/User/Preferences.sublime-settings" ]:
    require => [ Package['SublimeText2'], Repository["/Users/${::boxen_user}/dotfiles"] ],
    target  => "/Users/${::boxen_user}/dotfiles/Preferences.sublime-settings",
  }

  file {
    [ "$sublime_package_dir/User" ]:
    ensure => directory,
    require => Package['SublimeText2'],
  }
  sublime_text_2::package { 'Package Control':
    source => 'wbond/sublime_package_control',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Theme - Soda':
    source => 'buymeasoda/soda-theme',
    require => Package['SublimeText2'],
  }
  sublime_text_2::package { 'Rspec':
    source => 'SublimeText/RSpec',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Apply Syntax':
    source => 'facelessuser/ApplySyntax',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Git':
    source => 'kemayo/sublime-text-2-git',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Ctags':
    source => 'SublimeText/CTags',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Zen Coding':
    source => 'sergeche/emmet-sublime',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Sublime Linter':
    source => 'SublimeLinter/SublimeLinter',
    require => Package['SublimeText2']
  }
  sublime_text_2::package { 'Nettuts+ Fetch':
    source => 'weslly/Nettuts-Fetch',
    require => Package['SublimeText2']
  }

  mysql::db { 'mydb': }

  ## Ruby 1.9.3
  ruby::gem { 'pry for 1.9.3':
    gem     => 'pry',
    ruby    => '1.9.3',
  }
  ruby::gem { 'pry-nav for 1.9.3':
    gem     => 'pry-nav',
    ruby    => '1.9.3',
  }
  ruby::gem { 'pry-theme for 1.9.3':
    gem     => 'pry-theme',
    ruby    => '1.9.3',
  }
  ruby::gem { 'awesome_print for 1.9.3':
    gem     => 'awesome_print',
    ruby    => '1.9.3',
    version => '~> 1.2.0'
  }

  ## Ruby 2.0.0
  ruby::gem { 'pry for 2.0.0':
    gem     => 'pry',
    ruby    => '2.0.0'
  }
  ruby::gem { 'pry-nav for 2.0.0':
    gem     => 'pry-nav',
    ruby    => '2.0.0',
  }
  ruby::gem { 'pry-theme for 2.0.0':
    gem     => 'pry-theme',
    ruby    => '2.0.0',
  }
  ruby::gem { 'awesome_print for 2.0.0':
    gem     => 'awesome_print',
    ruby    => '2.0.0',
  }
}

