#!/bin/sh

# ================================================
# Description: Run compass watch in background
# GistID: 965f3e1a0876592db33f
# GistURL https://gist.github.com/allex/965f3e1a0876592db33f
# Author: Allex Wang (allex.wxn@gmail.com)
# Last Modified: Fri Aug 08, 2014 11:08AM
# ================================================

cmd_dir=`pwd`
pidfile="$cmd_dir/.sass.pid"
logfile="$cmd_dir/.sass.log"

if [ -f $pidfile ]; then
    kill -9 `cat $pidfile` >/dev/null 2>&1
    [ "$1" = "stop" ] && echo 'shutdown!' && exit 0;
fi

set -e

cd $cmd_dir
if [ ! -f "$cmd_dir/config.rb" ]; then
    echo "config.rb not found. please run 'compass init' first."
    exit 0;
fi

nohup compass watch>$logfile 2>&1&
echo $! >$pidfile
cd - >/dev/null 2>&1

echo "compass watch success, pid: $!";
