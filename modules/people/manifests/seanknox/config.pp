class people::seanknox::config {

  osx::recovery_message { 'If this Mac is found, please call and collect your reward: 415-401-5633': }

  ## Common OSX default configurations
  include osx::global::expand_print_dialog ## expand the print dialog by default
  include osx::global::expand_save_dialog ## expand the save dialog by default
  include osx::global::enable_keyboard_control_access ## enables the keyboard for navigating controls in dialogs
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access ## Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)

  ## Finder
  include osx::finder::show_all_on_desktop
  include osx::finder::show_hidden_files
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
  class { 'osx::global::key_repeat_delay':
      delay => 0
  }
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

  # Bluetooth
  boxen::osx_defaults { 'Improve the quality of Bluetooth Audio':
    key    => '"Apple Bitpool Min (editable)"',
    domain => 'com.apple.BluetoothAudioAgent',
    value  => '40',
    user   => $::boxen_user
  }

  osx_login_item {
    'Alfred 2':
      name    => 'Alfred 2',
      path    => '/Applications/Alfred 2.app',
      hidden  => true;

    'Dropbox':
      name    => 'Dropbox',
      path    => '/Applications/Dropbox.app',
      hidden  => true;
  }

}

