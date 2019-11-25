# vim: et:ts=2:sw=2:sts=2:ff=unix:fdm=marker:

# ignore tmux
# [ -n "$TMUX" ] && return

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

pathmunge () {
  case ":${PATH}:" in
    *:"$1":*)
      ;;
    *)
      if [ "$2" = "after" ] ; then
        PATH=$PATH:$1
      else
        PATH=$1:$PATH
      fi
  esac
}

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Idetify OS
export OS=`uname -s | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVER=`expr "$(uname -r)" : '[^0-9]*\([0-9]*\.[0-9]*\)'`

export EDITOR="vim"

# JDK
if [ "$OS" = "darwin" ]; then
  JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
fi
export JAVA_HOME=${JAVA_HOME:-/usr/local/java/jdk}

# ANT
export ANT_HOME="/usr/local/ant"
export M2_HOME="/usr/local/maven"

# Node
export NODE_PATH=$HOME/.node_libraries:$HOME/node_modules:$NODE_PATH:/usr/local/nodejs/lib/node_modules:/usr/local/node-modules/lib/node_modules
export NODE_ENV="production"

pathmunge /usr/local/bin
pathmunge /usr/local/sbin
pathmunge /usr/local/git/bin

# Use GNU Command instead of BSD
pathmunge /usr/local/coreutils/bin

pathmunge /usr/local/nodejs/bin
pathmunge /usr/local/node-modules/bin

# Set PATH so it includes user's private bin
pathmunge $HOME/bin
pathmunge $HOME/.bin
pathmunge $HOME/.yarn-global/node_modules/.bin
pathmunge $HOME/node_modules/.bin after
pathmunge ./node_modules/.bin after
pathmunge ./bin

# Go

export GOPATH=$HOME/local/go/packages
pathmunge /usr/local/go/bin
pathmunge $GOPATH/bin

# python
export PYTHONPATH=$HOME/local/python/2.7/site-packages
pathmunge "$PYTHONPATH"

# ruby
pathmunge /usr/local/ruby*/bin
pathmunge "$HOME/.rvm/bin" # Add RVM to PATH for scripting

unset -f pathmunge

# Include .bashrc if running bash.
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

[ "$GIT_DEPLOY_KEY" ] || GIT_DEPLOY_KEY="$HOME/.ssh/id_rsa"

# remove duplicate entries
export PATH=`printf %s "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++'`

##
# Your previous /Users/allex/.profile file was backed up as /Users/allex/.profile.macports-saved_2019-06-25_at_10:12:27
##

# MacPorts Installer addition on 2019-06-25_at_10:12:27: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# dismiss macos default interactive shell is now zsh
export BASH_SILENCE_DEPRECATION_WARNING=1
