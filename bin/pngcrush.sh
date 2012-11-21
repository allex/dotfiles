#!/bin/sh

copy() {
    local source=$1
    local target=$2
    if [ ! -d `dirname $target` ]; then
        mkdir -m 755 -p $(dirname $target)
    fi
    cp -Rfp $source $target
}

input="./images.orignal"
out="./images"

[ ! -d $out ] && mkdir -m 755 -p $out;
out=$(readlink -f $out);

cd $input

# Create directory structure only
for d in $(find `ls -l | awk ' /^d/ { print $NF } '` -type d -name "*" -print | grep -v '/\.'); do
    if [ ! -d $out/$d ]; then
        mkdir -m 755 -p $out/$d;
    fi
done

# pngcrush *.png.
for f in `find . -name "*.png"`; do
    pngcrush -rem allb -brute -reduce $f $out/$f
done

# *.jpg, *.gif
for f in $(find . -name "*.gif"); do copy $f $out/$f; done
for f in $(find . -name "*.jpg"); do copy $f $out/$f; done

cd -
