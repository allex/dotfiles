# vim: set ft=sh fdm=marker et ff=unix sw=4:

# ~/.bash_aliases
# author: Allex Wang (allex.wxn@gmail.com)

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then

    [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## svn aliases {{{

# diff with color highlighting
if [ -x "$(which colordiff 2>/dev/null)" ]; then
    function svndf()
    {
        svn diff "$@" | colordiff | less -SR;
    }
else
    # http://www.zalas.eu/viewing-svn-diff-result-in-vim
    svndiff()
    {
      svn diff "$@" | vim -M -
    }
fi

svngrep()
{
    # Modified from http://ceardach.com/
    if [ -z "$2" ]; then
        svn status | egrep "${1}" | awk '{print $2}'
    else
        svn ${2} `svn status | egrep "${1}" | awk '{print $2}'`
    fi
}

if [ -x "$(which colordiff 2>/dev/null)" ]; then
    alias svndiff='svn diff --diff-cmd svnvimdiff'
fi

alias svnvi="svn log --verbose -r"
alias svnlg="svn log | perl -l40pe 's/^-+/\n/'"

## }}}

extract () {
    if [ -f $1 ] ; then
        case $1 in
          *.tar.bz2)   tar xjf $1     ;;
          *.tar.gz)    tar xzf $1     ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar e $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xf $1      ;;
          *.tbz2)      tar xjf $1     ;;
          *.tgz)       tar xzf $1     ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias rm='rm -i'
alias mv='mv -i'

# some userfull shortcut
alias ~='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'

# some more ls aliases
alias ll='ls -lF'
alias la='ls -hA'
alias l='ls -C'
# show most recent files at the bottom
alias ltr='ls -ltr'

alias md='mkdir -p'
alias curl='/usr/bin/curl -k'

alias q='exit'

[ -x "/usr/bin/vim" ] && alias vi='/usr/bin/vim'

if [ "$(id -u)" != "0" ]; then
    alias service='sudo service'
fi

# set easy_install profile path
[ -x "$(which easy_install 2>/dev/null)" ] && alias easy_install="$(which easy_install) --install-dir=$PYTHONPATH"

# aliases for Ubuntu distro
uname -a | grep -q "Ubuntu"
if [ $? -eq 0 ]; then

    alias logout='dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1'
    alias restartx='sudo restart lightdm'

    # if user is not root, pass all commands via sudo #
    if [ $UID -ne 0 ]; then
        alias reboot='sudo reboot'
        alias update='sudo apt-get upgrade'
    fi
fi
