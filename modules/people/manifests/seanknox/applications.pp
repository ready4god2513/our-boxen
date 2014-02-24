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

