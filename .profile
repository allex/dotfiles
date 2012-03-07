# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

# User specific environment and startup programs

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
    export PATH
fi

if [ -d "$HOME/.lib" ] ; then
    export LIB="$HOME/.lib"
fi

# JDK
export JAVA_HOME=/usr/lib/jvm/java-6-sun

# Ant
export ANT_HOME=/usr/share/ant-1.8.2
export PATH=${PATH}:${ANT_HOME}/bin

# nodejs
export NODE_PATH=${HOME}/.node_libraries:${HOME}/node_modules:$NODE_PATH
