# vim: et:ts=2:sw=2:sts=2:ff=unix:fdm=marker:

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
      if [ -d $1 ]; then
        if [ "$2" = "after" ] ; then
          PATH=$PATH:$1
        else
          PATH=$1:$PATH
        fi
      fi
  esac
}

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Idetify OS
export OS=`uname -s | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`expr "$(uname -r)" : '[^0-9]*\([0-9]*\.[0-9]*\)'`

export EDITOR="vim"

# JDK
if [ "$OS" = "darwin" ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
else
  export JAVA_HOME="/usr/local/java/jdk"
fi

# ANT
export ANT_HOME="/usr/local/ant"
export M2_HOME="/usr/local/maven"

# Node
export NODE_PATH="/usr/local/lib/node"
export NODE_PATH=$HOME/.node_libraries:$HOME/node_modules:$NODE_PATH

pathmunge "$HOME/node_modules/.bin"
pathmunge "./node_modules/.bin"

# Python
export PYTHONPATH=$HOME/local/python-packages
pathmunge $PYTHONPATH after

# Use GNU Command instead of BSD
pathmunge /usr/local/coreutils/bin

# Set PATH so it includes user's private bin
pathmunge $HOME/bin

# Show a random terminal welcome ascii message
if type cowsay>/dev/null 2>&1; then
  # fortune | cowsay -f $(ls /usr/share/cowsay | shuf -n1)
  fortune | cowsay -f $(cowsay -l | tail -n +2 | tr " " "\n" | shuf -n1)
fi

# Include .bashrc if running bash.
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

unset -f pathmunge
