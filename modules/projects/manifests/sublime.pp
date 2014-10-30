class projects::sublime {

  include sublime_text
  include sublime_text::config

  $sublime_package_dir = "/Users/${::boxen_user}/Library/Application Support/Sublime Text 3/Packages"

  file { [ "$sublime_package_dir/User" ]:
    ensure  => directory,
    require => [
      Package['Sublime Text']
    ]
  }

  sublime_text::package { 'Solarized Color Scheme':
    source  => 'SublimeColors/Solarized',
    require => Package['Sublime Text']
  }

  sublime_text::package { 'Package Control':
    source  => 'wbond/sublime_package_control',
    require => Package['Sublime Text']
  }

  file { "$sublime_package_dir/User/Preferences.sublime-settings":
      content => template('projects/sublime/Preferences.sublime-settings.erb'),
      require => [
        Sublime_Text::Package['Solarized Color Scheme'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'no'
  }

  file { "$sublime_package_dir/User/Package Control.sublime-settings":
      content => template('projects/sublime/PackageControl.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'no'
  }

  file { "$sublime_package_dir/User/SearchInProject.sublime-settings":
      content => template('projects/sublime/SearchInProject.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'no'
  }

  file { "$sublime_package_dir/User/SublimeLinter.sublime-settings":
      content => template('projects/sublime/SublimeLinter.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'no'
  }
}
