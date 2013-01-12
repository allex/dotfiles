# vim: set ft=sh:

# ~/.bash_aliases
# author: Allex (allex.wxn@gmail.com)

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

# diff with color highlighting
if [ -x "$(which colordiff 2>/dev/null)" ]; then
    function svndf()
    {
        svn diff $@ | colordiff | less -SR;
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

alias rm='rm -i'
alias mv='mv -i'
alias vi='/usr/bin/vim'

# some userfull shortcut
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../../'

# some more ls aliases
alias ll='ls -lXF'
alias la='ls -XA'
alias l='ls -CXF'

# show most recent files at the bottom
alias ltr='ls -ltr'

alias md='mkdir -p'
alias curl='/usr/bin/curl -k'
alias svndiff='svn diff --diff-cmd ~/bin/svnvimdiff'

if [ -x "$(which easy_install 2>/dev/null)" ]; then
    alias easy_install="$(which easy_install) --install-dir=$PYTHONPATH"
fi

# alias for Ubuntu
uname -a | grep -q "Ubuntu"
if [ $? -eq 0 ]; then
    alias logout='dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1'
    alias restartx='sudo restart lightdm'
fi
