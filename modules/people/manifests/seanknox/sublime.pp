class people::seanknox::sublime {

  include sublime_text
  include sublime_text::config

  $sublime_package_dir = "/Users/${::boxen_user}/Library/Application Support/Sublime Text 3/Packages"
  $dotfiles = $people::seanknox::dotfiles

  file { [ "$sublime_package_dir/User" ]:
    ensure  => directory,
    require => [
      Package['Sublime Text'],
    ]
  }

  file { "$sublime_package_dir/User/Preferences.sublime-settings":
    require   => [
      Package['Sublime Text'],
      Repository["$dotfiles"],
      File["$sublime_package_dir/User"]
    ],
    target => "$dotfiles/Preferences.sublime-settings"
  }

  file { "$sublime_package_dir/User/Package Control.sublime-settings":
    require   => [
      Package['Sublime Text'],
      Repository["$dotfiles"],
      File["$sublime_package_dir/User"]
    ],
    target => "$dotfiles/Package Control.sublime-settings"
  }

  sublime_text::package { 'Package Control':
    source  => 'wbond/sublime_package_control',
    require => Package['Sublime Text']
  }
}
