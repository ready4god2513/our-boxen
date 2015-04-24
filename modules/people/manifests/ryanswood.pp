class people::ryanswood {

  $home = "/Users/${::boxen_user}"

  include people::ryanswood::applications
  include people::ryanswood::environment

  include projects::sublime
}

