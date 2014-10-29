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

  ## Boxen's 'template' provider. This ensures a file at
  ## ${boxen::config::srcdir}/dabo_act/config/database.yml will be created.
  ## It's going to use a template file to copy from, which is located in
  ## modules/projects/templates/dabo_act. The directory in the command is different—
  ## when using templates you store them in modules/projects/templates/<project-name>,
  ## and refer to their directory here with 'projects/<project-name>/[template-file]

  ## Last two things:
  ##  - it requires that the git repo ${boxen::config::srcdir}/dabo_act exists.
  ##    $boxen::config::srcdir is a built-in Boxen variable that points to ~/src, so on my machine
  ##    it would expand to /Users/sean/src.
  ##  - replace => 'no' means it won't clobber the file if it already exists.

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

  file { "$sublime_package_dir/User/Preferences.sublime-settings":
      content => template('projects/sublime/Preferences.sublime-settings.erb'),
      require => [
        Package['Sublime Text'],
        File["$sublime_package_dir/User"]
      ],
      replace => 'no'
  }


  sublime_text::package { 'Package Control':
    source  => 'wbond/sublime_package_control',
    require => Package['Sublime Text']
  }
}
