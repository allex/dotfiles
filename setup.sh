#!/bin/sh

dir=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)

cd $dir
git submodule update --init
cd - >/dev/null

case "`uname`" in
  CYGWIN* | Linux*)  ln="ln -sfn" ;;
  Darwin*) ln="ln -sfh" ;;
  *) echo "ln file fails, pls link it manaully."; exit 0 ;;
esac

$ln $dir/vim/.vimrc $HOME/.vimrc
$ln $dir/vim/.vim $HOME/.vim

$ln $dir/.bashrc $HOME/.bashrc
$ln $dir/.bash_aliases $HOME/.bash_aliases
$ln $dir/.bash_logout $HOME/.bash_logout
$ln $dir/.profile $HOME/.profile

$ln $dir/.gitconfig $HOME/.gitconfig
$ln $dir/.gitignore $HOME/.gitignore
$ln $dir/.jshintrc $HOME/.jshintrc
$ln $dir/.jshintignore $HOME/.jshintignore

echo "OK!"
