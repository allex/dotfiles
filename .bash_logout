# ~/.bash_logout: executed by bash(1) when login shell exits.

if [ -f "$HOME/.xsession-errors" ]; then
    rm -f "$HOME/.xsession-errors*"
fi

# fixes .goutputstream files polluting $HOME
rm $HOME/.goutputstream-* -rf

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
