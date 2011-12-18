# ~/.bash_aliases
# vim: set ft=sh:

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# diff with color highlighting
[ -x "$(which colordiff)" ] && function svndiff() { svn diff $@ | colordiff | less -SR; }

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias md='mkdir -p'

# enable sudo current user's private bin
alias sud='/usr/bin/sudo env PATH=$PATH'

# logout
alias logout='dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1'

