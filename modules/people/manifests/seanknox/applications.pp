class people::seanknox::applications {

  $globalruby = $people::seanknox::globalruby

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

  package  {  [
      'htop-osx',
      'watch',
      'wget',
      'tree',
      'pstree',
      'apg',
      ]:
        ensure => latest,
  }
  mysql::db { 'mydb': }

  ruby::gem { 'pry for $globalruby':
    gem     => 'pry',
    ruby    => "$globalruby",
  }
  ruby::gem { 'pry-nav for $globalruby':
    gem     => 'pry-nav',
    ruby    => "$globalruby",
  }
  ruby::gem { 'pry-theme for $globalruby':
    gem     => 'pry-theme',
    ruby    => "$globalruby",
  }
  ruby::gem { 'awesome_print for $globalruby':
    gem     => 'awesome_print',
    ruby    => "$globalruby",
  }
}

