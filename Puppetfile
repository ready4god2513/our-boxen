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

github "boxen", "3.3.8"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",    "1.0.1"
github "foreman",    "1.1.0"
github "gcc",        "2.0.1"
github "git",        "1.3.7"
github "go",         "2.0.1"
github "homebrew",   "1.6.0"
github "hub",        "1.3.0"
github "inifile",    "1.0.0", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",      "1.4.3"
github "nodejs",     "3.6.0"
github "openssl",    "1.0.0"
github "phantomjs",  "2.1.0"
github "pkgconfig",  "1.0.0"
github "repository", "2.2.0"
github "ruby",       "7.2.3"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.1"
github "module-data", "0.0.1", :repo => "ripienaar/puppet-module-data"

# System (additional)
github "osx",               "2.2.2"
github "sysctl",            "1.0.0"

# Development/Libs
github "python",            "1.3.0"
github "redis",             "2.1.0"
github "riak",              "1.1.0"
github "postgresql",        "3.0.1"
github "pow",               "1.0.0"
github "imagemagick",       "1.2.1"
github "cmake",             "1.0.1"
github "protobuf",          "1.0.0"
github "ctags",             "1.0.0"
github "mysql",             "1.2.0"

# Apps: All
github "iterm2",            "1.0.6"
github "macvim",            "1.0.0"
github "gitx",              "1.2.0"
github "dropbox",           "1.2.0"
github "tmux",              "1.0.2"
github "heroku",            "2.1.1"
github "sublime_text_2",    "1.1.2"
github "emacs",             "1.1.0"
# github "vim",               "1.0.4", :repo => "seanknox/puppet-vim"
github "vim",               "1.0.5"
github "chrome",            "1.1.2"
github "zsh",               "1.0.0"
github "skype",             "1.0.7"
github "virtualbox",        "1.0.10"
github "vagrant",           "3.0.4"

# Apps: Users
github "kindle",            "1.0.1"
github "alfred",            "1.1.7"
github "transmission",      "1.1.0"
github "onepassword",       "1.1.0"
github "skitch",            "1.0.2"
github "flux",              "1.0.0"
github "backblaze",         "0.0.1", :repo => "dabohealth/puppet-backblaze"

