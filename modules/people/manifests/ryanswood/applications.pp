class people::ryanswood::applications {
  include flux
  include openssl
  include cmake

  package  {  [
      'htop-osx',
      'watch',
      'tree',
      'pstree',
      'apg',
      ]:
        ensure => latest,
  }
}

