#!/bin/sh

# ================================================
# Description: %TITLE%
# Last Modified: Sat Sep 29, 2012 10:52AM
# Author: allex (allex.wxn@gmail.com)
# ================================================

xrandr --newmode $(cvt 1920 1080 60 | grep Mode | sed -e 's/.*"/1920x1080/')
xrandr --addmode VGA1 1920x1080
