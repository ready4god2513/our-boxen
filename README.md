# Dabo's Boxen

This is Dabo's incarnation of [GitHub's Boxen](https://boxen.github.com). Automated Mac provisioning. Use Boxen to setup a robust developer environment on your Mac in an hour or less (or your money back).

*This guide assumes you are running Boxen on a __clean install__ of OS X 10.8 (Mountain Lion) or 10.9 (Mavericks).Tested on:*
- *clean OS X 10.8*
- *clean OS X 10.9*

### Dependencies

- **You have a GitHub account, and have been added to the `dabohealth` organization.**
- **Install the Xcode Command Lines Tools and/or full Xcode.**

How do you do it?

#### OS X 10.9 (Mavericks)

If you are using [dabo-boxen-web](https://dabo-boxen-web.herokuapp.com)
or newer, it will be automatically installed as part of Boxen.
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
script/boxen --debug --profile
```
**Note**
If you are creating a fresh install on Xcode 5.1 there is a clang issue with
certain Ruby Gems. There is a Stackoverflow post [here](http://stackoverflow.com/questions/22352838/ruby-gem-install-json-fails-on-mavericks-and-xcode-5-1-unknown-argument-mul)

To run the Boxen script follow these instructions
```
cd /opt/boxen/repo
ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future ./script/boxen
```


Boxen will run for awhile, depending on the speed of your computer. After it finishes, your provisioning is now complete. Open a new terminal window to start using Boxen.

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

### Customizing your Boxen install
You can setup Boxen to install additional software or configuration by editing your personal .pp manifest file at `modules/people/manifests/$YOUR_GITHUB_HANDLE.pp`. This is useful if you want to do things like install your dotfiles, change your shell, or other important tasks. See [Sean Knox](https://github.com/seanknox) for help setting up a custom manifest, or take a look at an example one here [here](https://github.com/boxen/our-boxen/blob/master/modules/people/README.md).


## Initial Setup for the dabo_act Project

After the initial Boxen run, you can use Boxen to clone and automagically setup [dabo_act](https://github.com/dabohealth/dabo_act). Setup the project by:

`$ boxen dabo_act`

Boxen will:

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

