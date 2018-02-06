#!/bin/sh

# Usage: pngcrush.sh <src_dir> [out_dir]
#
# GistID: bb5f758dba3ae18176b4
# GistURL: https://gist.github.com/bb5f758dba3ae18176b4
# Author: Allex Wang (allex.wxn@gmail.com)

input="${1%/}"
out="${2%/}"
overwrite=
single_file=

if [ -z $input ] ; then
  echo "Usage: `basename $0` <in_dir> [out_dir]"
  exit 0
fi

if [ ! -r "$input" ]; then
  echo "fatal: \`input' not a valid file or directory. Stop."
  exit 1
fi

if [ -f $input ]; then
  single_file=1
fi

# overwrite mode
if [ ! $out ]; then
  overwrite=1
  out=`mktemp -d`
  ret=$?
  [ $ret -eq 0 ] || { echo "'mktemp' command not found. Exiting."; exit $ret; }
  __trap_exit() { [ -d "$out" ] && rm -rf $out; exit; }
  trap '__trap_exit' 0 1 2 3 13 15
fi

copy() {
  local source=$1
  local target=$2
  if [ ! -d `dirname $target` ]; then
    mkdir -m 755 -p $(dirname $target)
  fi
  cp -Rfp $source $target
}

# init pngcrush command location
pngcrush=`which pngcrush`;
if [ ! $pngcrush ]; then
  case "`uname`" in
    Linux*)
      if which yum >/dev/null 2>&1 ; then
        sudo yum -y install pngcrush
        [ $? -eq 0] || exit 1;
        pngcrush=`which pngcrush`
      fi
      ;;
    Darwin*)
      pngcrush="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush"
      ;;
  esac
  if [ ! $pngcrush ]; then
    echo "fatal: builtin \`pngcrush' not found. Stop"
    exit 1
  fi
fi

opti_png() {
  local f=$1
  local o=$2
  local dir=`dirname $o`
  [ -f $f ] && (
    # Original file size
    local orig_size=$(stat -c'%s' $f)
    if [ $overwrite ]; then
      printf "Optimizing $f..."
    else
      printf "$f => $o..."
    fi
    [ -d $dir ] || mkdir -m 755 -p $dir
    $pngcrush -q -rem allb -brute -reduce $f $o
    [ $? -eq 0 ] || cp -fp $f $o
    local opti_size=$(stat -c'%s' $o)
    # Get ratios
    local opti_ratio=$(echo "scale=1; 100 * ($orig_size - $opti_size) / $orig_size" | bc)
    printf '%6.2lf%%\n' $opti_ratio
    [ $overwrite ] && mv $o $f
  )
}

if [ $single_file ]; then
  if [ "${out#*.}" != "png" ]; then
    out="$out/`basename $input`"
  fi
  opti_png "$input" "$out"
else
  # pngcrush *.png.
  for f in `find $input -name "*.png" -type f`; do
    opti_png "$f" "`echo $f|sed -e "s#^$input#$out#g"`"
  done
fi

# *.jpg, *.gif etc,.
