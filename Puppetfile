# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.7.0"

# Support for default hiera data in modules

github "module_data", "0.0.4", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",     "2.0.0"
github "foreman",     "1.2.0"
github "gcc",         "2.2.0"
github "git",         "2.7.0"
github "go",          "1.1.0"
github "homebrew",    "1.9.6"
github "hub",         "1.3.0"
github "inifile",     "1.1.4", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.4.4"
github "nodejs",      "4.0.0"
github "openssl",     "1.0.0"
github "phantomjs",   "2.3.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "ruby",        "8.1.4"
github "stdlib",      "4.3.2", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",     "1.2.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

# System (additional)
github "osx",               "2.7.1"
github "sysctl",            "1.0.1"

# Development/Libs
github "python",            "1.3.0"
github "redis",             "3.1.0"
github "riak",              "1.1.3"
github "postgresql",        "3.0.1"
github "pow",               "2.1.0"
github "imagemagick",       "1.3.0"
github "cmake",             "1.0.1"
github "protobuf",          "1.0.0"
github "ctags",             "1.0.0"
github "mysql",             "1.99.9"

# Apps: All
github "iterm2",            "1.2.2"
github "macvim",            "1.0.0"
github "gitx",              "1.2.0"
github "dropbox",           "1.4.1"
github "tmux",              "1.0.2"
github "heroku",            "2.1.1"
github "sublime_text_2",    "1.1.2"
github "sublime_text",      "1.0.1"
github "emacs",             "1.1.0"
github "vim",               "1.0.5"
github "chrome",            "1.2.0"
github "zsh",               "1.0.0"
github "skype",             "1.0.9"
github "virtualbox",        "1.0.10"
github "vagrant",           "3.2.0"
github "wget",              "1.0.1"
github "flowdock",          "1.0.0"
github "googledrive",       "1.0.2"
github "dash",              "1.0.0"

# Apps: Users
github "kindle",            "1.0.1"
github "alfred",            "1.3.1"
github "transmission",      "1.1.0"
github "onepassword",       "1.1.2"
github "skitch",            "1.0.3"
github "flux",              "1.0.1"
github "rdio",              "1.0.0"

