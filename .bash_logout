# ~/.bash_logout: executed by bash(1) when login shell exits.
# Author: Allex Wang (allex.wxn@gmail.com)

exit

# ubuntu
if [ -f "$HOME/.xsession-errors" ]; then
  rm -f "$HOME/.xsession-errors*"
fi

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
  BREW_CACHE_D=`type brew &> /dev/null && brew --cache`
  if [ ! -z "$BREW_CACHE_D" ] && [ -d $BREW_CACHE_D ];
  then
    rm -rf $BREW_CACHE_D/*
  fi
  unset BREW_CACHE_D

  # cleanup brew caches
  rm -rf /Library/Caches/Homebrew/*

  # fixes .goutputstream files polluting $HOME
  rm -rf $HOME/.goutputstream-*

  rm -rf "$HOME/library/Containers/com.xiami.client/Data/Library/Caches/"*
  rm -rf "$HOME/library/Containers/com.apple.mail/Data/Library/Mail Downloads"/*
  rm -rf "$HOME/library/Caches/com.apple.Safari/WebKitCache"/*

  find "$HOME/library/Containers/com.tencent.qq/" -name FaceStore.db -print0 |xargs -0 rm -f
  find "$HOME/library/Containers/com.tencent.qq/" -name Image -type d -print0 |xargs -0 rm -rf

  if [ -n "$TMPDIR" -a -d "$TMPDIR" ]; then
    echo "Cleanup tempdir..."
    find "$TMPDIR" -depth -empty -type d -delete
  fi
fi
