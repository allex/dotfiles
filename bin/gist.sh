#!/bin/sh
# GistID: 8f9a8a45e86f0edef6caea81f0795031
echoerr() {
  echo "$@" 1>&2;
}
error() {
  if [ -t 1 ]; then
    echoerr "\033[1;31m$@\033[0m"
  else
    echoerr "$@"
  fi
}
die() {
  error $@
  exit 1
}
mkworkspace() {
  local tmpdir="${TMPDIR:-${TMP:-/tmp/}}gist/$1"
  mkdir -p -- "$tmpdir"
  printf "%s" "$tmpdir"
}
require_clean_work_tree_git () {
  git rev-parse --verify HEAD >/dev/null || exit 1
  git update-index -q --ignore-submodules --refresh
  err=0
  if ! git diff-files --quiet --ignore-submodules
  then
    echo >&2 "Cannot $1: You have unstaged changes."
    err=1
  fi
  if ! git diff-index --cached --quiet --ignore-submodules HEAD --
  then
    if [ $err = 0 ]
    then
      echo >&2 "Cannot $1: Your index contains uncommitted changes."
    else
      echo >&2 "Additionally, your index contains uncommitted changes."
    fi
    err=1
  fi
  if [ $err = 1 ]
  then
    test -n "$2" && echo >&2 "$2"
    exit 1
  fi
}

# read content from stdin
if [ -t 0 ]; then
  t=$(umask 077; mktemp)
  trap 'rm -f -- "$t"' 0 1 2 3 9 13 15
  cat - > "$t"
fi

gist_file="${1:-}"
if [ -s "$t" ]; then
  gist_file=$t
fi
[ -s "$gist_file" ] || die "gist content is mandatory."

gist_filename="$(basename $gist_file)"
[ -n "$gist_filename" ] || die "gist filename is required."

gist_id="${2:-$(head -n 20 ${gist_file} |grep -i "Gist_*ID: *"|sed -E "s#.*Gist_*ID: *([a-z0-9]+).*#\1#i")}"
[ -n "$gist_id" ] || die "gist id is required."

workspace="$(umask 077; mkworkspace ${gist_id})"

(cd $workspace || die "build gist workspace failed."
if [ -d ".git" ]; then
  git fetch origin master -q && git reset origin/master --hard >/dev/null
else
  git clone -q -b master git@gist.github.com:${gist_id}.git ./
fi) || exit $?

cat $gist_file > "$workspace/${gist_filename}"

(cd $workspace
if ! (require_clean_work_tree_git "release" "" 2>/dev/null) ; then
  (git add . -A; git commit -C HEAD --amend --no-edit --allow-empty-message) >/dev/null 2>&1
  git push origin master -f
else
  printf "Nothing changed."
fi)
