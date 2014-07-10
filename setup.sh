#!/bin/sh

dir=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)

ln -sfh $dir/vim/.vimrc $HOME/.vimrc
ln -sfh $dir/vim/.vim $HOME/.vim

ln -sfh $dir/.bashrc $HOME/.bashrc
ln -sfh $dir/.bash_aliases $HOME/.bash_aliases
ln -sfh $dir/.bash_logout $HOME/.bash_logout
ln -sfh $dir/.profile $HOME/.profile

ln -sfh $dir/.gitconfig $HOME/.gitconfig
ln -sfh $dir/.gitignore $HOME/.gitignore
ln -sfh $dir/.jshintrc $HOME/.jshintrc
