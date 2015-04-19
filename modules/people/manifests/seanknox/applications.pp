class people::seanknox::applications {
  include kindle
  include mysql
  include flux
  include transmission
  include zsh
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
}

