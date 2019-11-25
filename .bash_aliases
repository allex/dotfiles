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
alias g='git'

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

[ -n "$(which nvim 2>/dev/null)" ] && { alias vi="nvim"; } || alias vi=vim

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
  # Enable all of harmony, experimental feautues. i.e. import await-repl (by @allex_wang)
  __node_harmony_args=`${__node_cmd} --v8-options |\grep -- "--harmony" |cut -d" " -f3 |xargs`
  __node_harmony_args="${__node_harmony_args} --experimental-repl-await --experimental-vm-modules --experimental-worker"
  node() {
    local f="$1"
    if [ -f "$f" ] && [[ "$f" =~ .coffee$ ]]; then
      coffee "$f"
    else
      ${__node_cmd} ${__node_harmony_args} "$@";
    fi
  }
  node-inspect() {
    local cmd="$1"
    if [ ! -f "$cmd" ]; then
      # detect cmd full path
      local args=("${@}")
      args[0]=`which "$cmd"`
      local items=
      for i in "${args[@]}"
      do
        items="$items \"$i\""
      done
      eval set -- $items
    fi
    node --inspect --inspect-brk "$@"
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

# Generate shortcuts dots, ., .., ..., .... aliases
n=4; dot='.'
{
  while (( n > 0 )); do dot=".${dot}"; eval "alias $dot='__cd $dot'"; ((n-=1)); done;
}
unset n dot

[ ! -x "$(which pidof 2>/dev/null)" ] && \
{
  pidof() { echo `ps -ef | \grep $1 | awk '{print$2}'`; }
}

# Enhance grep with usefull excludes and `GREP_ARGS` env | MIT licensed by allex <http://iallex.com/>
__grep() {
  if [ $# -gt 0 ]; then
    local c x t="$PWD"
    while [ -n "$t" ]; do
      if [ -d "$t/.git" ]; then
        x="$t/.gitignore"
        break
      else
        t="${t%*/*}"
        [ "$t" = "${t//\/}" ] && break
      fi
    done
    c=(-I --color=auto --exclude-dir={.svn,.git,.*cache,*.tmp,dist,node_modules} --exclude={*.lock,.*.tmp})
    [ -s "$x" ] && {
      t="$HOME/.gitignore"
      [ -f "$t" ] && c+=(--exclude-from "$t")
      c+=(--exclude-from "$x")
    }
    [ -n "$GREP_ARGS" ] && c+=("${GREP_ARGS[@]}")
    c+=("$@")
    shopt -qo xtrace && echo "${c[@]}"
    set -- "${c[@]}"
  fi
  if [ ! -t 0 ]; then
    \grep -v grep | \grep "$@"
  else
    \grep "$@"
  fi
}
alias grep="__grep"

##############################
#
# Usefull function definations
#
##############################

psgrep() {
  c="ps aux |\grep '$1' |\grep -v grep |awk '{print \$2}'"
  if [ "$2" = "kill" ]; then
    eval $c |xargs kill -9
  else
    eval $c
  fi
}

#
# Helper function for auto prefix ssh, scp host
# Author: Allex Wang (allex.wxn@gmail.com)
# MIT Licensed
#
__find_ssh_prefix () {
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
  done < <(cat ~/.ssh/config |\grep "^#def")
}

__autoprefix_ssh_hosts() {
  local len=0 level diff user host m
  host=$1
  m=`\grep -Po '\w+@[^: ]+' <<< "$host"`
  if [ "$m" ]; then
    read user host <<< "`echo $m|tr '@' ' '`"
  fi
  host=${host##.}
  host=${host%%.}
  level=`printf $host |sed "s#[0-9]*##g"`
  [ -n "$level" ] && len=${#level}
  diff=$((3-${len}))
  if [[ "$host" =~ ^[0-9.]+$ ]] && [ $diff -ne 0 ]; then
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
        prefix=( $(printf "$prefix" |tr '.' '\n') )
        prefix=( ${prefix[@]:0:$diff} )
        local n h=''
        for n in "${prefix[@]}"; do h=${h}.${n}; done
        host="${h##.}.$host"
        printf "$user@$host"
        return
      fi
    fi
  fi
  printf "${user:+${user}@}${host}"
}

# Enhances with auto completion with host prefix and default user
#
# Author: Allex Wang (allex.wxn@gmail.com)
# MIT Licensed
#
# GistID: 0f844bbe583a1e40548d
# GistURL: https://gist.github.com/allex/0f844bbe583a1e40548d
#
ssh() {
  local host commands p parsed args=(-o GSSAPIAuthentication=no)
  commands=()
  while [ $# -gt 0 ]; do
    p=$1
    shift
    [ x"$p" = x"--" ] && break
    case "$p" in
      -v | -T)
        args+=("$p")
        ;;
      -*)
        args+=("$p")
        case "$1" in -* | "") continue ;; esac
        args+=("$1")
        shift
        ;;
      *)
        if ! [ $parsed ]; then
          parsed=1
          args+=("$(__autoprefix_ssh_hosts $p)")
        else
          commands+=("$p")
        fi
        ;;
    esac
  done
  for p in "$@"; do
    commands+=("$p")
  done
  set -- "${args[@]:-}" -- "${commands[@]}"
  if type -t ssh-pearl >/dev/null 2>&1; then
    ssh-pearl "$@"
  else
    command ssh "$@"
  fi
}

scp() {
  # check for missing colons
  if (($# >= 2)) && [[ $* != *:* ]] ; then
    printf 'scp: Missing colon, probably an error\n' >&2
    return 1
  fi
  command scp -o GSSAPIAuthentication=no "$@"
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

ip() {
  # networksetup -setmanualwithdhcprouter WI-FI 192.168.0.66
  ifconfig |grep 'inet '|awk '{if($2!="127.0.0.1")print $2}'
}
