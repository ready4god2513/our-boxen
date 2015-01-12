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

  sublime_text::package { 'Sodarized Color Theme':
    source  => 'jrolfs/sodarized',
    require => Package['Sublime Text']
  }

  sublime_text::package { 'Seti_UI':
    source  => 'ctf0/Seti_ST3',
    require => Package['Sublime Text']
  }

  sublime_text::package { 'Soda Color Theme':
    source  => 'buymeasoda/soda-theme',
    require => Package['Sublime Text']
  }

  sublime_text::package { 'Tomorrow Color Schemes':
    source  => 'theymaybecoders/sublime-tomorrow-theme',
    require => Package['Sublime Text']
  }

  sublime_text::package { 'SublimeLinter':
    source  => 'SublimeLinter/SublimeLinter3',
    require => Package['Sublime Text']
  }

  sublime_text::package { 'Vintageous Surround':
    source  => 'guillermooo/Vintageous_Plugin_Surround',
    require => Package['Sublime Text']
  }

  repository { "$sublime_package_dir/Package Control":
    source  => 'wbond/sublime_package_control',
    ensure  => '6a8b91ca58d66cb495b383d9572bb801316bcec5',
    require => Package['Sublime Text']
  }

  file { "$sublime_package_dir/User/Preferences.sublime-settings":
      content => template('projects/sublime/Preferences.sublime-settings.erb'),
      require => [
        Sublime_Text::Package['Solarized Color Scheme'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'yes'
  }

  file { "$sublime_package_dir/User/Package Control.sublime-settings":
      content => template('projects/sublime/Package Control.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'yes'
  }

  file { "$sublime_package_dir/User/SearchInProject.sublime-settings":
      content => template('projects/sublime/SearchInProject.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'yes'
  }

  file { "$sublime_package_dir/User/SublimeLinter.sublime-settings":
      content => template('projects/sublime/SublimeLinter.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'yes'
  }

  file { "$sublime_package_dir/User/Default (OSX).sublime-keymap":
    content => template('projects/sublime/Default (OSX).sublime-keymap.erb'),
    require => [
      Package['Sublime Text'],
      File["$sublime_package_dir/User"]
    ],
    replace => 'yes'
  }

  file { "$sublime_package_dir/User/DashDoc.sublime-settings":
    content => template('projects/sublime/DashDoc.sublime-settings.erb'),
    require => [
      Package['Sublime Text'],
      File["$sublime_package_dir/User"]
    ],
    replace => 'yes'
  }

  file { "$sublime_package_dir/User/bindingpry.sublime-snippet":
    content => template('projects/sublime/bindingpry.sublime-snippet.erb'),
    ensure => present,
    require => [
      Package['Sublime Text'],
      File["$sublime_package_dir/User"]
    ]
  }

  file { "$sublime_package_dir/User/consolelog.sublime-snippet":
    content => template('projects/sublime/consolelog.sublime-snippet.erb'),
    ensure => present,
    require => [
      Package['Sublime Text'],
      File["$sublime_package_dir/User"]
    ]
  }

  boxen::env_script { "bundler_editor_sublime":
    content => template('projects/sublime/bundler_editor.sh')
  }
}
