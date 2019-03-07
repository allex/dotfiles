# vim: ft=sh:et:ts=2:sw=2:sts=2:ff=unix:fdm=marker:

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# author: Allex Wang (allex.wxn@gmail.com)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

__require() {
  local f=$1;
  [ -f "$f" ] && [ -r "$f" ] && { source $f; return 0; }
  return 1;
}

# Colors
CLICOLOR=1

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE='&:ls:cd:[bf]g:exit:q:..:...:ll:la:l:h:history'
HISTTIMEFORMAT='%d/%m/%y %T '

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## PS1 by Allex {{{

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-256color | xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
else
  # set variable identifying the chroot you work in (used in the prompt below)
  if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
  fi
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
for f in "$HOME/.git-prompt.sh" "$HOME/.dotfiles/git-prompt.sh" ; do
  __require $f && break
done; unset f

if type -t __git_ps1 >/dev/null 2>&1; then
  PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
fi

## Add by Allex Wang, 2011/05/08
## http://bash.cyberciti.biz/guide/Changing_bash_prompt
__ps1_cwd() {
  # How many characters of the $PWD should be kept
  local maxlen=15 dir=${PWD##*/}
  local p=${PWD/#$HOME/\~}
  local parts=(`echo ${p} | tr "/" " "`)
  # Indicate that there has been dir truncation
  local trunc_symbol="${parts[0]}/..."
  [ "${trunc_symbol:0:1}" = "~" ] || trunc_symbol="/${trunc_symbol}"
  maxlen=$(( ( maxlen < ${#dir} ) ? ${#dir} : maxlen ))
  local offset=$(( ${#p} - maxlen ))
  if [ ${offset} -gt "0" ]; then
    p=${p:$offset:$maxlen}
    p=${trunc_symbol}/${p#*/}
  fi
  printf $p
}

__ps1_init() {
  # 27 = 033 = 0x1b = ^[ = \e
  local c_reset="\[\e[0m\]" # unsets color to term's fg color

  # regular colors
  local k="\[\e[0;30m\]" # black
  local r="\[\e[0;31m\]" # red
  local g="\[\e[0;32m\]" # green
  local y="\[\e[0;33m\]" # yellow
  local b="\[\e[0;34m\]" # blue
  local m="\[\e[0;35m\]" # magenta
  local c="\[\e[0;36m\]" # cyan
  local w="\[\e[0;37m\]" # white

  # emphasized (bolded) colors
  local em_k="\[\e[1;30m\]"
  local em_r="\[\e[1;31m\]"
  local em_g="\[\e[1;32m\]"
  local em_y="\[\e[1;33m\]"
  local em_b="\[\e[1;34m\]"
  local em_m="\[\e[1;35m\]"
  local em_c="\[\e[1;36m\]"
  local em_w="\[\e[1;37m\]"

  # background colors
  local b_k="\[\e[40m\]"
  local b_r="\[\e[41m\]"
  local b_g="\[\e[42m\]"
  local b_y="\[\e[43m\]"
  local b_b="\[\e[44m\]"
  local b_m="\[\e[45m\]"
  local b_c="\[\e[46m\]"
  local b_w="\[\e[47m\]"

  local prompt_delimit='\\$'
  local u_c=$c

  if [ $UID -eq "0" ]; then
    prompt_delimit='#'
    u_c=$r # root's color
  fi

  local _user="\u"
  local _pwd="${em_g}\$(__ps1_cwd)" # \W
  local _git_ps1=

  if [ -n "${SSH_CLIENT:-$SSH_TTY}" ]; then
    local hostname=`hostname`
    # show current connection ip if hostname is 'localhost'
    if [ "${hostname%%.*}" = "localhost" ]; then
      ip=`echo ${SSH_CONNECTION}|cut -f3 -d ' '`
      _user="\u@${ip:-\h}"
    else
      _user="\u@\h"
    fi
  fi

  if type -t __git_ps1 >/dev/null 2>&1; then
    _git_ps1="\$(__git_ps1 \" ${em_c}(%s)${c_reset}\" 2>/dev/null)"
  fi

  PS1="${m}${_user}${c_reset} ${_pwd}${_git_ps1} ${u_c}${prompt_delimit}${c_reset} "
}

[ "$color_prompt" = yes ] && __ps1_init || unset __ps1_cwd

unset __ps1_init color_prompt force_color_prompt

## END PS1 }}}

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

__require ~/.bash_aliases
__require ~/.bash_local

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Make Terminal’s autocompletion case-insensitive
bind 'set completion-ignore-case On'

# Cycle through autocomplete options in Ubuntu’s Terminal with the TAB key
bind '"\C-i" menu-complete'

# <C-l> clear screen
# bind -m vi-insert "\C-l":clear-screen
bind -x '"\C-l": clear;'

# Adding Git Autocomplete to Bash
__require "$HOME/.dotfiles/git-completion.bash"

# Adding mvn Autocomplete to Bash <https://github.com/juven/maven-bash-completion>
__require "$HOME/.dotfiles/maven_bash_completion.bash"

unset -f __require

if [ -n "$SSH_TTY" ] && type cowsay>/dev/null 2>&1
then
  # Show a random terminal welcome ascii message By Allex Wang
  fortune | cowsay -f $(cowsay -l | tail -n +2 | tr " " "\n" | shuf -n1) | lolcat
fi

# Don't Match Useless Files in Filename Completion
# <https://docstore.mik.ua/orelly/unix3/upt/ch28_07.htm>
# <https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html>
export FIGNORE=".swp:.tmp:.pyc:.o:"

PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# cleanup $PATH
export PATH="`echo -n $PATH | awk -v RS=: -v ORS=: '!arr[$0]++'`"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd $FD_OPTS . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d $FD_OPTS . "$1"
}

export FD_OPTS="--hidden -d 10 --exclude '.git' --ignore-file $HOME/.gitignore"
export FZF_DEFAULT_COMMAND="fd --type f $FD_OPTS"
export FZF_DEFAULT_OPTS="--bind ctrl-f:page-down,ctrl-b:page-up"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'head -100 {}'"
