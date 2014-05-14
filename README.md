# Dabo's Boxen

This is Dabo's incarnation of [GitHub's Boxen](https://boxen.github.com). Automated Mac provisioning. Use Boxen to setup a robust developer environment on your Mac in an hour or less (or your money back).

*This guide assumes you are running Boxen on a __clean install__ of OS X 10.8 (Mountain Lion) or 10.9 (Mavericks).Tested on:*
- *clean OS X 10.8*
- *clean OS X 10.9*
- Command Line Tools or Xcode >= `5.1.0.0.1.1396320587`

### Dependencies

- **You have a GitHub account, and have been added to the `dabohealth` organization.**
- **Install the Xcode Command Lines Tools and/or full Xcode.**

How do you do it?

#### OS X 10.9 (Mavericks)

If you are using [dabo-boxen-web](https://dabo-boxen-web.herokuapp.com)
or newer, Command Line Tools will be automatically installed as part of Boxen.
Otherwise, follow instructions below.

#### OS X < 10.9

1. Install Xcode from the Mac App Store.
1. Open Xcode.
1. Open the Preferences window (`Cmd-,`).
1. Go to the Downloads tab.
1. Install the Command Line Tools.


### Boxenify me

Install Boxen by either:
* Using [Dabo Boxen Web](https://dabo-boxen-web.herokuapp.com) *(easiest)*, or
* Alternatively, open Terminal.app and do the following:

```bash
sudo mkdir -p /opt/boxen
sudo chown ${USER}:staff /opt/boxen
git clone https://github.com/dabohealth/dabo-boxen.git /opt/boxen/repo
cd /opt/boxen/repo
script/boxen
```

Boxen will run for awhile, depending on the speed of your computer. After it finishes, your provisioning is now complete. Open a new terminal window to reinitialize your shell and start using your system.

## What You Get

### System stuff:
* Homebrew
* Git *(your GitHub login credentials are encrypted and stored on your local filesystem—no more entering username/password)*
* Hub
* dnsmasq w/ .dev resolver for localhost
* rbenv
* Node.js 0.10
* Ruby 1.9.3
* Ruby 2.0.0 *(set as default)*
* Ruby 2.1.0
* gcc
* ack
* Findutils
* GNU tar
* The Silver Searcher (`ag` command: a faster alternative to `ack`)

### Mac Apps
* Chrome
* Dropbox
* iTerm2
* Virtualbox
* tmux
* Backblaze installer

### Shell setup and Environment variables
Boxen ensures it is first in your $PATH so there is no more confusion to where your Ruby/Python/gem/etc. binary is. Additionally, Boxen setups up handy shell variables for Boxen and all services installed through Boxen. For example:
* `$BOXEN_HOME`
* `$BOXEN_REDIS_URL`
* `$BOXEN_POSTGRESQL_HOST`
* `$BOXEN_POSTGRESQL_PORT`

Run `boxen --env` to see a full list.

### Where Boxen lives
Boxen is installed into `/opt/boxen`, as is all software installed through Boxen (Homebrew, rbenv, phantomenv, nodenv, etc.)
#### Homebrew
Homebrew is installed into `/opt/boxen/homebrew`, not the usual `/usr/local/` path. Any Homebrew package *should* work fine, but some packages may have hardcoded `/usr/local/` as an install path.
#### rbenv / Ruby
`rbenv` is installed into `/opt/boxen/rbenv`. All ruby versions are installed into `/opt/rubies`.

### Customizing your Boxen install
You can setup Boxen to install additional software or configuration by editing your personal .pp manifest file at `modules/people/manifests/$YOUR_GITHUB_HANDLE.pp`. This is useful if you want to do things like install your dotfiles, change your shell, or other important tasks. See [Sean Knox](https://github.com/seanknox) for help setting up a custom manifest, or take a look at an example one here [here](https://github.com/boxen/our-boxen/blob/master/modules/people/README.md).

### Updating Boxen
Periodically you should update and re-run Boxen to update your system—any required Ruby versions, Homebrew packages, etc. will automatically be upgraded or installed for you. Updating is a two-step process:

1. Grab the latest version of Boxen: `cd /opt/boxen/repo && git pull`
2. Run Boxen: `boxen all`

*The 'all' parameter is important—it tells Boxen to install all additional projects (including dabo_act) along with global configuration.* 

## Setup for the dabo_act project

After the (initial bootstraping run)[https://github.com/dabohealth/dabo-boxen/blob/master/README.md#boxenify-me], you can use Boxen to clone and automagically setup [dabo_act](https://github.com/dabohealth/dabo_act). Setup the project by:

`$ boxen all` 
- install all projects (at the moment there is only `dabo_act`, but running `boxen all` is good for future-proofing additional Dabo-managed projects).
`$ boxen dabo_act` 
- install only the dabo_act project.

In either case Boxen will:

* Clone the repo
* Ensure the correct version of Ruby is installed
* Ensure Redis, Postgresql, PhantomJS are all installed and running
* Install Heroku command line tools
* Prepare default config/database.yml
* Prepare default .env
* Install project version of Ruby and automatically run `bundle install`
* Run migrations and load seed data and sample data
* Prepare databases for parallel tests *(see [https://github.com/dabohealth/dabo_act#testing](https://github.com/dabohealth/dabo_act#testing) for more info)*
* Ensure $REDISTOGO_URL is set in your shell
* Install Mailcatcher gem
* Setup nginx/dnsmasq to allow accessing the development server at `http://dabo_act.dev/`

At this point you can start the app. You'll need to manually add your AWS credentials to .env. Ask a dev lead on how to do this.

For more information about the Boxen project, including more details about custom manifests, check out GitHub's official [Boxen page.](https://github.com/boxen/our-boxen)

