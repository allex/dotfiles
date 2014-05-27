# ~/.bash_logout: executed by bash(1) when login shell exits.

if [ -f "$HOME/.xsession-errors" ]; then
    rm -f "$HOME/.xsession-errors*"
fi

# fixes .goutputstream files polluting $HOME
rm -rf $HOME/.goutputstream-*

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# OS X
if [ "$OS" = "darwin" ]; then
    # osx diagnostic resports
    if [ -d $HOME/library/Logs/DiagnosticReports ]; then
        rm -rf $HOME/library/Logs/DiagnosticReports/* &>/dev/null
    fi
    # cleanup brew cache
    BREW_CACHE_D=`type cowsay &> /dev/null && brew --cache`
    if [ ! -z "$BREW_CACHE_D" ] && [ -d $BREW_CACHE_D ];
    then
        rm -rf $BREW_CACHE_D/*
    fi
    unset BREW_CACHE_D
fi
