# Dabo's Boxen

This is Dabo's incarnation of [GitHub's Boxen](https://boxen.github.com). Automated Mac provisioning.

## Getting Started with Boxen at Dabo:
*tested on:*
- *clean OS X 10.8*
- *clean OS X 10.9*

### Dependencies

**You have a GitHub account, and have been added to the `dabohealth` organization.**
**Install the Xcode Command Lines Tools and/or full Xcode.**

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
*This guide assumes you are running Boxen on a __clean install__ of OS X 10.8 (Mountain Lion) or 10.9 (Mavericks).*

Install Boxen by either:
* Using [Dabo Boxen Web](https://dabo-boxen-web.herokuapp.com) *(easiest)*, or
* Open Terminal.app and do the following:

```bash
sudo mkdir -p /opt/boxen
sudo chown ${USER}:staff /opt/boxen
git clone https://github.com/dabohealth/dabo-boxen.git /opt/boxen/repo
cd /opt/boxen/repo
script/boxen --debug --profile
```

Boxen will run for awhile, depending on the speed of your computer. After it finishes, your provisioning is now complete.

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
Boxen ensures it is first in your $PATH so there is no confusion to where your Ruby binary is. Additionally, Boxen setups up handy shell variables for Boxen and all services installed through Boxen. For example:
* `$BOXEN_HOME`
* `$BOXEN_REDIS_URL`
* `BOXEN_POSTGRESQL_HOST`
* `BOXEN_POSTGRESQL_PORT`

Run `boxen --env` to see a full list.

### Customizing your Boxen install
You can setup Boxen to install additional software or configuration by editing your personal .pp manifest file at `modules/people/manifests/$YOUR_GITHUB_HANDLE.pp`. This is useful if you want to install your dotfiles, change your shell, or other important tasks. See [Sean Knox](https://github.com/seanknox) for help setting up a custom manifest, or take a look at an example one here [here](https://github.com/boxen/our-boxen/blob/master/modules/people/README.md).


## Initial Setup for the dabo_act Project

After the initial Boxen run, you can use Boxen to clone and automagically setup [dabo_act](https://github.com/dabohealth/dabo_act). Setup the project by:

`$ boxen dabo_act`

Boxen will:

* Clone the repo
* Ensure Redis, Postgresql, PhantomJS are all installed and running
* Install project version of Ruby and automatically run `bundle install`
* Prepare default config/database.yml
* Load seed data and sample data

At this point you should be done—you can stop reading and start shipping. For more information about the Boxen project, including more details about custom manifests, check out GitHub's official [Boxen page.](https://github.com/boxen/our-boxen)

