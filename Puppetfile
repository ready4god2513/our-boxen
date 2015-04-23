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
  mod "puppet-#{name}", :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.10.4"

# Support for default hiera data in modules

github "module_data", "0.0.4", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "brewcask",    "0.0.6"
github "dnsmasq",     "2.0.1"
github "foreman",     "1.2.0"
github "gcc",         "2.2.1", :repo => "mriddle/puppet-gcc"
github "git",         "2.7.7"
github "go",          "2.1.0"
github "homebrew",    "1.11.2"
github "hub",         "1.4.0"
github "inifile",     "1.2.0", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.4.5"
github "nodejs",      "4.0.1"
github "openssl",     "1.0.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "ruby",        "8.5.0"
github "stdlib",      "4.5.1", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"

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
github "mysql",             "2.0.0"

# Apps: All
github "gitx",              "1.2.0"
github "heroku",            "2.1.1"
github "sublime_text",      "1.0.2"
github "vim",               "1.0.5"
github "zsh",               "1.0.0"
github "virtualbox",        "1.0.10"
github "vagrant",           "3.2.0"
github "wget",              "1.0.1"

# Apps: Users
github "kindle",            "1.0.1"
github "transmission",      "1.1.0"
github "onepassword",       "1.1.3"
github "skitch",            "1.0.3"
github "flux",              "1.0.1"
github "rdio",              "1.0.0"
github "sourcetree",        "1.0.0"
