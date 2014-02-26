class people::seanknox::sublime {

  include sublime_text_2
  include sublime_text_2::config

  $sublime_package_dir = "/Users/${::boxen_user}/Library/Application Support/Sublime Text 2/Packages"
  $dotfiles = "/Users/${boxen_user}/dotfiles"

  file { [ "$sublime_package_dir/User" ]:
    ensure  => directory,
    require => [
      Package['SublimeText2'],
    ]
  }

  file { "$sublime_package_dir/User/Preferences.sublime-settings":
    require   => [
      Package['SublimeText2'],
      Repository["/Users/${::boxen_user}/dotfiles"],
      File["$sublime_package_dir/User"]
    ],
    target => "$dotfiles/Preferences.sublime-settings"
  }

  file { "$sublime_package_dir/User/Package Control.sublime-settings":
    require   => [
      Package['SublimeText2'],
      Repository["/Users/${::boxen_user}/dotfiles"],
      File["$sublime_package_dir/User"]
    ],
    target => "$dotfiles/Package Control.sublime-settings"
  }

  sublime_text_2::package { 'Package Control':
    source  => 'wbond/sublime_package_control',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'sublime-file-operations':
    source  => 'chasetopher/sublime-file-operations',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'sublime-text-puppet':
    source  => 'eklein/sublime-text-puppet',
    require => Package['SublimeText2']
  }
}
