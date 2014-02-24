class people::seanknox::sublime {

  $sublime_package_dir = "/Users/${::boxen_user}/Library/Application Support/Sublime Text 2/Packages"

  file {
      [ "$sublime_package_dir/User/Preferences.sublime-settings" ]:
      require => [ Package['SublimeText2'], Repository["/Users/${::boxen_user}/dotfiles"] ],
      target  => "/Users/${::boxen_user}/dotfiles/Preferences.sublime-settings",
    }

  file {
    [ "$sublime_package_dir/User" ]:
    ensure => directory,
    require => Package['SublimeText2'],
  }

  sublime_text_2::package { 'Package Control':
    source => 'wbond/sublime_package_control',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Theme - Soda':
    source => 'buymeasoda/soda-theme',
    require => Package['SublimeText2'],
  }

  sublime_text_2::package { 'Rspec':
    source => 'SublimeText/RSpec',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Apply Syntax':
    source => 'facelessuser/ApplySyntax',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Git':
    source => 'kemayo/sublime-text-2-git',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Ctags':
    source => 'SublimeText/CTags',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Zen Coding':
    source => 'sergeche/emmet-sublime',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Sublime Linter':
    source => 'SublimeLinter/SublimeLinter',
    require => Package['SublimeText2']
  }

  sublime_text_2::package { 'Nettuts+ Fetch':
    source => 'weslly/Nettuts-Fetch',
    require => Package['SublimeText2']
  }
}
