# Dabo's Boxen

This is Dabo's incarnation of [GitHub's Boxen](https://boxen.github.com).
Automated Mac provisioning. Use Boxen to setup a robust developer
environment on your Mac in an hour or less (or your money back).

## Before Getting Started
### Boxen on a Fresh Install of OS X

*This guide assumes you are running Boxen on a __clean install__ of
OS X 10.8 (Mountain Lion) or 10.9 (Mavericks). Tested on:*
- *clean OS X 10.8*
- *clean OS X 10.9*
- Command Line Tools or Xcode >= `5.1.0.0.1.1396320587`

### Boxen on an Existing System
There are a few potential conflicts to keep in mind.
Boxen does its best not to get in the way of a dirty system,
but you should check  the following before attempting to install your
boxen on any machine (we do some checks before every Boxen run to try
and detect most of these and tell you anyway):

* Boxen __requires__ at least the Xcode Command Line Tools installed.
* Boxen __will not__ work with an existing rvm install.
* Boxen __may not__ play nice with a GitHub username that includes dash(-)
* Boxen __may not__ play nice with an existing rbenv install.
* Boxen __may not__ play nice with an existing chruby install.
* Boxen __may not__ play nice with an existing homebrew install.
* Boxen __may not__ play nice with an existing nvm install.
* Boxen __recommends__ installing the full Xcode.

## Prerequisites for All Systems

- You have a GitHub account and it has been added to the `dabohealth` organization.
- If on OS X 10.8, you will need to install the Xcode Command Lines Tools and/or full Xcode.
*(Xcode CLT are installed automatically on OS X 10.9)*

### OS X < 10.9
OS X 10.8 users will need to install Xcode before running Boxen.

1. Install Xcode from the Mac App Store.
1. Open Xcode.
1. Open the Preferences window (`Cmd-,`).
1. Go to the Downloads tab.
1. Install the Command Line Tools.

## Getting Started

To give you a brief overview, we're going to:

* Install dependencies
* Bootstrap your box to use dabo-boxen
* Setup your system with all the tools and software you need to run [dabo_act](https://github.com/dabohealth/dabo_act)

## Boxenify me

Install Boxen by either:

* Use the web-based [Dabo Boxen Web](https://dabo-boxen-web.herokuapp.com) *(easiest)*, or
* Alternatively, open Terminal.app and do the following:

```bash
sudo mkdir -p /opt/boxen
sudo chown ${USER}:staff /opt/boxen
git clone https://github.com/dabohealth/dabo-boxen.git /opt/boxen/repo
cd /opt/boxen/repo
script/boxen all
```

Boxen will run for awhile, depending on the speed of your computer. After it
finishes, your provisioning is now complete. Open a new terminal window to
reinitialize your shell and start using your system. The `dabo_act` project will
also be cloned and setup in `~/src/dabo_act`. Yippee!

## What You Get

### System stuff:
* Homebrew
* Git *(your GitHub login credentials are encrypted and stored on your local filesystem—no more entering username/password)*
* Hub
* dnsmasq w/ .dev resolver for localhost
* rbenv
* Node.js 0.10.31
* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.4 *(set as default)*
* Heroku Toolbelt
* gcc
* ack
* Findutils
* GNU tar
* The Silver Searcher (`ag` command: a faster alternative to `ack`)

### Including boxen modules from github (boxen/puppet-<name>)

You must add the github information for your added Puppet module into your Puppetfile at the root of your
boxen repo (ex. /path/to/your-boxen/Puppetfile):

    # Core modules for a basic development environment. You can replace
    # some/most of these if you want, but it's not recommended.

    github "repository", "2.0.2"
    github "dnsmasq",    "1.0.0"
    github "gcc",        "1.0.0"
    github "git",        "1.2.2"
    github "homebrew",   "1.1.2"
    github "hub",        "1.0.0"
    github "inifile",    "0.9.0", :repo => "cprice404/puppetlabs-inifile"
    github "nginx",      "1.4.0"
    github "nodejs",     "2.2.0"
    github "ruby",       "4.1.0"
    github "stdlib",     "4.0.2", :repo => "puppetlabs/puppetlabs-stdlib"
    github "sudo",       "1.0.0"

    # Optional/custom modules. There are tons available at
    # https://github.com/boxen.

    github "java",     "1.6.0"

* tmux
includes the Java module from Github using the tag "1.6.0" from the github repository
* The [dabo_act](https://github.com/dabohealth/dabo_act) application (almost) completely configured and ready to run.
and takes the name of the module, the version, and optional repo location:

    def github(name, version, options = nil)
      options ||= {}
      options[:repo] ||= "boxen/puppet-#{name}"
      mod name, version, :github_tarball => options[:repo]
    end

Now Puppet knows where to download the module from when you include it in your site.pp or mypersonal.pp file:

    # include the java module referenced in my Puppetfile with the line
    # github "java",     "1.6.0"
    include java

### Hiera

Hiera is preferred mechanism to make changes to module defaults (e.g. default
global ruby version, service ports, etc). This repository supplies a
starting point for your Hiera configuration at `config/hiera.yml`, and an
example data file at `hiera/common.yaml`. See those files for more details.

### Mac Apps
* Chrome
* Google Drive
* iTerm2
* Virtualbox
* Sublime Text 3 with Dabo Engineering setup
* Flowdock

### Shell setup and Environment variables
Boxen ensures it is first in your $PATH so there is no more confusion to where
your Ruby/Python/gem/etc. binary is. Additionally, Boxen setups up handy
shell variables for Boxen and all services installed through Boxen. For example:
* `$BOXEN_HOME`
* `$BOXEN_REDIS_URL`
* `$BOXEN_POSTGRESQL_HOST`
* `$BOXEN_POSTGRESQL_PORT`

Run `boxen --env` to see a full list.

### Where Boxen lives
Boxen is installed into `/opt/boxen`, as is all software installed
through Boxen (Homebrew, rbenv, phantomenv, nodenv, etc.)
#### Homebrew
Homebrew is installed into `/opt/boxen/homebrew`, not the
usual `/usr/local/` path. Any Homebrew package *should*
 work fine, but some packages may have hardcoded `/usr/local/` as an install path.
#### rbenv / Ruby
`rbenv` is installed into `/opt/boxen/rbenv`. All ruby
versions are installed into `/opt/rubies`.

### Customizing your Boxen install
You can setup Boxen to install additional software or
configuration by editing your personal .pp manifest file
at `modules/people/manifests/$YOUR_GITHUB_HANDLE.pp`.
This is useful if you want to do things like install your dotfiles,
change your shell, or other important tasks.  Take a look at an
example one here [here](https://github.com/boxen/our-boxen/blob/master/modules/people/README.md).

### Updating Boxen
Whenever Boxen is run, it will automatically attempt to fetch
the latest version from the [dabohealth/dabo-boxen](https://github.com/dabohealth/dabo-boxen) repo.
Thus, you can ensure you have an up to date system and `dabo_act` application setup by simply running:
```
boxen all
```

*The 'all' parameter is important—it tells Boxen to install all additional projects (including dabo_act) along with the global configuration.*

## Boxen and the dabo_act project

After running Boxen the first time, [dabo_act](https://github.com/dabohealth/dabo_act) will be cloned and setup for you.

Any time you run `boxen all` or `boxen dabo_act`, Boxen will ensure the following is done or already done:

* Clone the  [dabo_act](https://github.com/dabohealth/dabo_act)  repo
* Ensure Redis, Postgresql, PhantomJS are all installed and running
* Install Heroku command line tools
* Prepare default config/database.yml
* Prepare default .env
* Install project version of Ruby and automatically run `bundle install`
* Run migrations and load seed data and sample data
* Prepare databases for parallel tests *(see [https://github.com/dabohealth/dabo_act#testing](https://github.com/dabohealth/dabo_act#testing) for more info)*
* Install Mailcatcher gem
* Setup nginx/dnsmasq to allow accessing the development server at `http://dabo_act.dev/`

At this point you can start the app. You'll need to manually add your AWS credentials to .env. Ask a dev lead on how to do this.

For more information about the Boxen project, including more details about custom manifests, check out GitHub's official [Boxen page.](https://github.com/boxen/our-boxen)

