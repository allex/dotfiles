# ~/.bash_aliases
# vim: set ft=sh:

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

# some more ls aliases
alias cd..='cd ..'
alias ll='ls -lXF'
alias la='ls -A'
alias l='ls -CF'
alias md='mkdir -p'
alias curl='/usr/bin/curl -k'

# enable sudo current user's private bin
alias sud='/usr/bin/sudo env PATH=$PATH'

# logout
alias logout='dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1'

# restart x
alias restartx='sudo restart lightdm'
