# vim: ft=sh:ff=unix:fdm=marker:et:sw=2:ts=2:sts=2:

# ~/.bash_aliases
# author: Allex Wang (allex.wxn@gmail.com)

alias rm='rm -i'
alias mv='mv -i'

alias ~='cd ~'
alias cd..='cd ..'

# some userfull shortcut
alias md='mkdir -p'
alias curl='/usr/bin/curl -k'
alias q='exit'

# some more ls aliases
alias ll='ls -lh'
alias la='ls -hA'
alias l='ls -C'
alias ltr='ls -ltr' # show most recent files at the bottom

alias grep='grep -I'
alias cp='cp --preserve'
alias zcat='gunzip -c'

alias diskspace="sudo du -k `pwd` | sort -n"
alias dig="dig +noall +answer"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr | %cn)%Creset' --abbrev-commit --date=relative"

# enable color support of ls and also add handy aliases
if type -t dircolors &>/dev/null; then

  # https://github.com/seebi/dircolors-solarized
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || \
  {
    export LS_COLORS='no=00;38;5;244:rs=0:di=00;38;5;33:ln=00;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:ex=00;38;5;64:*.tar=00;38;5;61:*.tgz=00;38;5;61:*.zip=00;38;5;61:*.z=00;38;5;61:*.bz2=00;38;5;61:*.gem=00;38;5;61:*.jpg=00;38;5;136:*.gif=00;38;5;136:*.png=00;38;5;136:*.svg=00;38;5;136:*.ico=00;38;5;136:';
  }

  alias ls='ls --color=auto'
  alias ll='ls -lhX'  # group directories first

  # For *nix
  if [ "$OS" = "linux" ]; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi

else

  if [ "$OS" = "darwin" ]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad

    # OSX SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
    alias ls="ls -G"
  fi
fi

[ -n "$(which nvim 2>/dev/null)" ] && { alias vi="nvim"; alias vim=nvim; } || alias vi=vim
[ "$(id -u)" != "0" ] && alias service='sudo service'

# set easy_install profile path
[ -x "$(which easy_install 2>/dev/null)" ] && alias easy_install="$(which easy_install) --install-dir=$PYTHONPATH"

# aliases for Ubuntu distro {{{
__uname=`uname -a`
if [ "$__uname" != "${__uname/Ubuntu /}" ]; then
  # if user is not root, pass all commands via sudo #
  if [ $UID -ne 0 ]; then
      alias reboot='sudo reboot'
      alias update='sudo apt-get upgrade'
  fi
  alias open='/usr/bin/nautilus'
  alias restartx='sudo restart lightdm'
  alias logout='dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1'
  # Add an "alert" alias for long running commands.  Use like so:
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi
unset __uname
# }}}

__node_cmd=`which node 2>/dev/null`; [ -n "${__node_cmd}" ] && \
{
  # Enable all of node features locked by `--harmony*', i.e. ES6
  # By Allex Wang <https://nodejs.org/en/docs/es6/>
  __node_harmony_args=`${__node_cmd} --v8-options |\grep -- "--harmony" |cut -d" " -f3 |xargs`
  node() {
    local f="$1"
    if [ -f "$f" ] && [[ "$f" =~ .coffee$ ]]; then
      coffee "$f"
    else
      ${__node_cmd} ${__node_harmony_args} "$@";
    fi
  }
}

# svn helper {{{

# diff with color highlighting
if [ -x "$(which colordiff 2>/dev/null)" ]; then
  svndf() { svn diff "$@" | colordiff | less -SR; }
else
  # http://www.zalas.eu/viewing-svn-diff-result-in-vim
  svndf() { svn diff "$@" | vim -M -; }
fi

# Usage: svngrep ? st
svngrep()
{
  local p="${1}"
  if [ "${p}" = "?" ]; then
    p="\\?"
  fi
  # Modified from http://ceardach.com/
  if [ -z "$2" ]; then
    svn st | egrep "${p}" | awk '{print $2}'
  else
    svn "${2}" `svn st | egrep "${p}" | awk '{print $2}'`
  fi
}

svnvi() { svn log --verbose -r; }
svnlog() { svn log "$@" | perl -l40pe 's/^-+/\n/'; }
svnadd() {
  svngrep "^\!"|xargs svn rm
  svngrep "^\?"|xargs svn add
}

alias svndiff='svn diff -x "-w --ignore-eol-style" --diff-cmd svndiff.sh'

# }}}

# common extract
x() {
  if [ ! -r "$1" ]; then
    echo "file is unreadable: '$1'" >&2
    return 1;
  fi
  case $1 in
    *.tar.bz2)   tar xjf $1     ;;
    *.tar.gz)    tar xzf $1     ;;
    *.bz2)       bunzip2 $1     ;;
    *.rar)       unrar e $1     ;;
    *.gz)        gunzip $1      ;;
    *.tar)       tar xf $1      ;;
    *.tbz2)      tar xjf $1     ;;
    *.tgz | *.gz2) tar xzf $1   ;;
    *.zip)       unzip $1       ;;
    *.Z)         uncompress $1  ;;
    *.7z |*.crx) 7z x $1        ;;
    *.xz)        xz --decompress $1;;
    *)           echo "unrecognized file extension: '$1'" >&2
  esac
}

# generate dots aliases by allex
n=6; dot='.'; while (( n > 0 )); do dot=".${dot}"; eval "alias $dot='__cd $dot'"; ((n-=1)); done; unset n dot

# cd enhancments
__cd() {
  if   [[ "x$*" == "x..." ]]; then
    __cd ../..
  elif [[ "x$*" == "x...." ]]; then
    __cd ../../..
  elif [[ "x$*" == "x....." ]]; then
    __cd ../../../..
  elif [[ "x$*" == "x......" ]]; then
    __cd ../../../../..
  else
    \cd "$@"
  fi
}

[ ! -x "$(which pidof 2>/dev/null)" ] && \
{
  pidof() { echo `ps -ef | grep $1 | awk '{print$2}'`; }
}

##############################
#
# Usefull function definations
#
##############################

psgrep() {
  if [ "$2" = "kill" ]; then
    ps aux | \grep "$1" | \grep -v grep | awk '{print $2}' | xargs kill -9;
  else
    ps aux | \grep "$1" | \grep -v grep | awk '{print $2}';
  fi
}

# Wrap scp to check for missing colons
scp() {
  if (($# >= 2)) && [[ $* != *:* ]] ; then
    printf 'scp: Missing colon, probably an error\n' >&2
    return 1
  fi
  command scp -o GSSAPIAuthentication=no "$@"
}

# Extends with specified shortcut completion with host prefix and default user
# Author: Allex Wang (allex.wxn@gmail.com)
# MIT Licensed
# GistID: 0f844bbe583a1e40548d
# GistURL: https://gist.github.com/allex/0f844bbe583a1e40548d
ssh() {
  local user host=$1
  local m=`grep -Po '\w+@[^ ]+' <<< "$host"`
  if [ "$m" ]; then
    read user host <<< "`echo $m|tr '@' ' '`"
  fi
  if [[ "$host" =~ ^[0-9]+$ ]]; then
    local x k v u prefix
    local config=$HOME/.ssh/config
    if [[ -r $config ]]; then
      local fix=1
      while read t k v
      do
        if [ "$t" == "#def" ]; then
          case "$k" in
            USERNAME) user=${user:-$v} ;;
            PREFIX)   prefix=$v ;;
          esac
        elif [[ "$t" == "Host" && "$k" == "$host" ]]; then
          fix=0
          break
        fi
      done < "$config"
      # auto fix the default host prefix and user if not config specified.
      if [ $fix -eq 1 ]; then
        set -- "$user@$prefix.$host"
      fi
    fi
  fi
  local args=('-o GSSAPIAuthentication=no')
  if type -t ssh-pearl >/dev/null 2>&1; then
    ssh-pearl "$args" "$@"
  else
    /usr/bin/ssh "$args" "$@"
  fi
}

# Completion for ssh/sftp/ssh-copy-id with config hostnames
__comp_ssh() {
  local word=${COMP_WORDS[COMP_CWORD]}

  # Bail if the configuration file is illegible
  local config=$HOME/.ssh/config
  if [[ ! -r $config ]] ; then
    return 1
  fi

  # Read hostnames from the file, no asterisks
  local -a hosts
  local option value
  while read -r option value _ ; do
    if [[ $option == Host && $value != *'*'* ]] ; then
      hosts=("${hosts[@]}" "$value")
    fi
  done < "$config"

  # Generate completion reply
  COMPREPLY=( $(compgen -W "${hosts[*]}" -- "$word") )
}

complete -o default -F __comp_ssh \
  ssh sftp ssh-copy-id scp

__git_cmd=`which git 2>/dev/null`; [ -n "${__git_cmd}" ] && \
{
  git() {
    local gitdir worktree
    local git="${__git_cmd}"
    if ! $git rev-parse --show-toplevel &>/dev/null; then
      if [ -s "./.g/HEAD" ]; then
        gitdir=./.g
      else
        gitdir=`ls -1 ./*/HEAD 2>/dev/null|sed "s#/HEAD##g"`
      fi
      local args="$*"
      local base="/opt/git/$(basename `pwd`).git"
      if [ ! -d "$gitdir" ] && [ -d "$base" ]; then
        gitdir="$base"
      fi
      [ -d "$gitdir" ] && \
      {
        git=$git" --git-dir=$gitdir"
        worktree="$($git rev-parse --show-toplevel 2>/dev/null)"
        [ "${args/--work-tree=* //}" = "$args" ] && [ "$worktree" ] && git=$git" --work-tree=$worktree"
      }
    fi
    $git "$@"
  }

  # create a new git repo in cwd
  gitinit() {
    git init
    printf ".DS_Store\n.*.swp\n*~\n" > .gitignore
    git add .gitignore
    git ci -m "initializing repo" .gitignore
  }
}

