require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  # if $::root_encrypted == 'no' {
  #   fail('Please enable full disk encryption and try again')
  # }

  git::config::global{
    'color.ui': value => 'auto';
    'core.autocrlf': value => 'input';
    'alias.st':    value => 'status';
    'alias.a':    value => 'add';
    'alias.aa':    value => 'add --all';
    'alias.ci':    value => 'commit';
    'alias.br':    value => 'branch';
    'alias.co':    value => 'checkout';
    'alias.df':    value => 'diff';
    'alias.pr':    value => 'pull --rebase';
    'alias.lg':    value => "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)an>%Creset' --abbrev-commit";
    'alias.hist':  value => "log --pretty=format:'%Cgreen%h%Creset %Cblue%ad%Creset %C(magenta)%cn%Creset%C(yellow)%d%Creset%n        %s' --graph --date=local";
    'alias.lol':    value => 'log --graph --decorate --pretty=oneline --abbrev-commit';
    'alias.ls':    value => 'ls-files';
    'alias.cp':    value => 'cherry-pick';
    'alias.rp':    value => 'remote prune';
    'alias.rpo':    value => 'remote prune origin';
    'alias.pom':  value => 'push origin master';
    'alias.g':    value => 'grep --break --heading --line-number';
    'alias.rbm':    value => '!git fetch origin master && git rebase origin/master';
    'alias.gpc':    value => 'push --set-upstream origin $(git-branch-current 2> /dev/null)';
    'alias.unstage':    value => 'reset HEAD';
    'push.default.':    value => 'current';
    'difftool.prompt':    value => 'false';
    'grep.linenumber':    value => 'true';
 }

  # node versions
  nodejs::version { 'v0.10': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  ruby::version { '2.1.2': }
  ruby::version { '2.1.3': }
  ruby::version { '2.1.4': }

  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.0',
    ruby_version => '*',
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'the_silver_searcher'
    ]:
  }

  file { "${boxen::config::srcdir}/dabo-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  $global_nodejs_version = 'v0.10'

  # set global nodejs version
  class { 'nodejs::global':
    version => $global_nodejs_version
  }

  nodejs::module { 'bower':
    node_version => $global_nodejs_version
  }

  # COMMON APPS
  include chrome
  include dropbox
  include iterm2::stable
  include virtualbox
  include tmux
  include flowdock
  include googledrive
  include dash

  # OS X CONFIG
  osx::recovery_message { "If this Mac is found, please email: phu@dabohealth.com": }
  # Download and enable software updates
  include osx::software_update

  ## Common OSX default configurations
  include osx::global::expand_print_dialog ## expand the print dialog by default
  include osx::global::expand_save_dialog ## expand the save dialog by default
  include osx::global::enable_keyboard_control_access ## enables the keyboard for navigating controls in dialogs
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access ## Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)

  ## Finder
  include osx::finder::unhide_library

  boxen::osx_defaults { 'Use Column view in all Finder windows by default':
    key    => 'FXPreferredViewStyle',
    domain => 'com.apple.Finder',
    value  => 'clmv',
    user   => $::boxen_user
  }

  boxen::osx_defaults { 'Show Path bar in Finder':
    key    => 'ShowPathbar',
    domain => 'com.apple.Finder',
    value  => 'true',
    user   => $::boxen_user
  }

  # Keyboard
  class { 'osx::global::key_repeat_rate':
    rate => 2
  }

  ## Misc
  include osx::no_network_dsstores ## disable creation of .DS_Store files on network shares
  include osx::disable_app_quarantine ## disable the downloaded app quarantine

  boxen::osx_defaults { 'Change software update check frequency to daily':
    key    => 'ScheduleFrequency',
    domain => 'com.apple.SoftwareUpdate',
    value  => '1',
    user   => $::boxen_user
  }
  boxen::osx_defaults { 'Prevent Time Machine from prompting to use new hard drives as backup volume':
    key    => 'DoNotOfferNewDisksForBackup',
    domain => 'com.apple.TimeMachine',
    value  => 'true',
    user   => $::boxen_user
  }
  boxen::osx_defaults { 'Enable magnification':
    key    => 'magnification',
    domain => 'com.apple.dock',
    value  => 'true',
    user   => $::boxen_user
  }
  boxen::osx_defaults { 'Automatically illuminate built-in MacBook keyboard in low light':
    key    => 'kDim',
    domain => 'com.apple.BezelServices',
    value  => 'true',
    user   => $::boxen_user
  }
  boxen::osx_defaults { 'Turn off keyboard illumination when computer is not used for 5 minutes':
    key    => 'kDimTime',
    domain => 'com.apple.BezelServices',
    value  => '300',
    user   => $::boxen_user
  }

  osx_login_item {
    'Dropbox':
      name    => 'Dropbox',
      path    => '/Applications/Dropbox.app',
      hidden  => true;
  }

}
