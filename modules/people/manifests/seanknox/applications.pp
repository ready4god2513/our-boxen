class people::seanknox::applications {

  $globalruby = $people::seanknox::globalruby

  include virtualbox
  include tmux
  include iterm2::stable
  include dropbox
  include kindle
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
  include wget
  include rdio

  package  {  [
      'htop-osx',
      'watch',
      'tree',
      'pstree',
      'apg',
      ]:
        ensure => latest,
  }
  mysql::db { 'mydb': }

  ruby_gem { "pry for $globalruby":
    gem     => 'pry',
    ruby_version    => "$globalruby",
  }
  ruby_gem { "pry-nav for $globalruby":
    gem     => 'pry-nav',
    ruby_version    => "$globalruby",
  }
  ruby_gem { "pry-theme for $globalruby":
    gem     => 'pry-theme',
    ruby_version    => "$globalruby",
  }
  ruby_gem { "awesome_print for $globalruby":
    gem     => 'awesome_print',
    ruby_version    => "$globalruby",
  }
}

