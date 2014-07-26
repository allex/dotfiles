#!/bin/sh

# ================================================
# Description: killport.sh
# GistID: 8b399a93749703acd780
# GistURL: https://gist.github.com/allex/8b399a93749703acd780
# Last Modified: Sun Jul 13, 2014 12:45PM
# Author: Allex Wang (allex.wxn@gmail.com)
# ================================================

port=$1
while [[ -z "${port}" ]]; do
    read -p "Please type the port you wanna kill (q to exit): " port
done

[ "${port}" = "q" ] && exit 0;

PID=""
case "`uname `" in
    Linux*)  PID=`lsof -t -i:${port}` ;;
    Darwin*) PID=`lsof -i -n -P | grep ":${port} (LISTEN)" | awk '{print $2}'` ;;
esac

if [ -n "$PID" ];
then
    kill -9 $PID && echo "procss with pid: ${PID} on port ${port} had killed success!"
else
    echo "The specific process with port '${port}' not found. exit";
fi
