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
    "${boxen::config::homebrewdir}/bin",
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
    'alias.aa':    value => 'add --all';
    'alias.ci':    value => 'commit';
    'alias.rcm':   value => 'commit -c HEAD --reset-author';
    'alias.br':    value => 'branch';
    'alias.co':    value => 'checkout';
    'alias.df':    value => 'diff';
    'alias.pr':    value => 'pull --rebase';
    'alias.lg':    value => "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)>%Creset' --abbrev-commit";
    'alias.hist':  value => "log --pretty=format:'%Cgreen%h%Creset %Cblue%ad%Creset %C(magenta)%cn%Creset%C(yellow)%d%Creset%n        %s' --graph --date=local";
    'alias.lol':    value => 'log --graph --decorate --pretty=oneline --abbrev-commit';
    'alias.ls':    value => 'ls-files';
    'alias.cp':    value => 'cherry-pick';
    'alias.rp':    value => 'remote prune';
    'alias.rpo':    value => 'remote prune origin';
    'alias.pom':  value => 'push origin master';
    'alias.gr':    value => 'grep --break --heading --line-number';
    'alias.rbm':    value => '!git fetch origin master && git rebase origin/master';
    'alias.gpc':    value => 'push --set-upstream origin $(git-branch-current 2> /dev/null)';
    'alias.unstage':    value => 'reset HEAD';
    'alias.recent-commits': value => '"!recent_commits() { git log --pretty=format:\"%ad -- %an -- %d -- %B\" --date=relative --branches --since=7.days.ago --author=\"$1\"; }; recent_commits"';
    'alias.old-branches': value => '"!old_branches() { for branch in `git branch -r | grep -v HEAD`; do echo -e `git show --format=\"%ci %cr\" $branch | head -n 1` \\t$branch; done | sort -r; }; old_branches;"';
    'push.default.':    value => 'current';
    'difftool.prompt':    value => 'false';
    'grep.linenumber':    value => 'true';
    'branch.autosetuprebase': value =>  'always';
 }

  file { "${boxen::config::home}/bin/git-pair":
    source => "puppet:///${boxen::config::home}/repo/manifests/files/git-pair",
    replace => 'yes'
  }

  # node versions
  nodejs::version { 'v0.12.0': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  ruby::version { '2.1.2': }
  ruby::version { '2.1.3': }
  ruby::version { '2.1.4': }
  ruby::version { '2.1.5': }
  ruby::version { '2.2.0': }
  ruby::version { '2.2.1': }

  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.0',
    ruby_version => '*',
  }

  ruby_gem { 'zeus':
    gem          => 'zeus',
    version      => '~> 0.15.0',
    ruby_version => '*',
  }

  ruby_gem { 'pry':
    gem          => 'pry',
    version      => '~> 0.10.1',
    ruby_version => '*',
  }

  ruby_gem { 'pry-coolline':
    gem          => 'pry-coolline',
    version      => '~> 0.2.4',
    ruby_version => '*',
  }

  ruby_gem { 'awesome_print':
    gem          => 'awesome_print',
    version      => '~> 1.6.1',
    ruby_version => '*',
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'the_silver_searcher',
      'tig'
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
  include brewcask
  include sourcetree
  include heroku
  include virtualbox
  package { 'slack': provider => 'brewcask' }
  package { 'google-chrome': provider => 'brewcask' }
  package { 'dropbox': provider => 'brewcask' }
  package { 'alfred': provider => 'brewcask' }
  package { 'spectacle': provider => 'brewcask' }
  package { 'clipmenu': provider => 'brewcask' }
  package { 'dash': provider => 'brewcask' }
  package { 'google-drive': provider => 'brewcask' }
  package { 'iterm2': provider => 'brewcask' }
  package { 'skitch': provider => 'brewcask' }
  package { 'tmux': }

  file { "/Users/${::boxen_user}/Library/Preferences/com.divisiblebyzero.Spectacle.plist":
    source => "puppet:///${boxen::config::home}/repo/manifests/files/com.divisiblebyzero.Spectacle.plist",
    replace => 'yes',
    require => Package['spectacle']
  }

  file { "/Users/${::boxen_user}/Library/Preferences/com.naotaka.ClipMenu.plist":
    source => "puppet:///${boxen::config::home}/repo/manifests/files/com.naotaka.ClipMenu.plist",
    replace => 'yes',
    require => Package['clipmenu']
  }

  # OS X CONFIG
  # Download and enable software updates
  # include osx::software_update

  ## Common OSX default configurations
  include osx::global::expand_print_dialog ## expand the print dialog by default
  include osx::global::expand_save_dialog ## expand the save dialog by default
  include osx::global::enable_keyboard_control_access ## enables the keyboard for navigating controls in dialogs
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access ## Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
  include osx::global::tap_to_click ## enables tap to click
  include osx::dock::autohide ## automatically hide the dock
  include osx::finder::show_all_on_desktop
  include osx::no_network_dsstores ## disable creation of .DS_Store files on network shares
  include osx::disable_app_quarantine ## disable the downloaded app quarantine
  include osx::finder::show_hidden_files
  include osx::finder::unhide_library
  include osx::keyboard::capslock_to_control

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

  class { 'osx::global::key_repeat_delay':
    delay => 1
  }


  boxen::osx_defaults { 'Change software update check frequency to daily':
    key    => 'ScheduleFrequency',
    domain => 'com.apple.SoftwareUpdate',
    value  => '7',
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
}
