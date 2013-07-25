#!/bin/bash

# vim configuration
ln -s $HOME/.dotfiles/vim ~/.vim
ln -s $HOME/.vim/vimrc ~/.vimrc

# ctags
ln -s $HOME/.dotfiles/ctags/ctags ~/.ctags

# ruby
ln -s $HOME/.dotfiles/ruby/gemrc ~/.gemrc
ln -s $HOME/.dotfiles/ruby/pryrc ~/.pryrc
ln -s $HOME/.dotfiles/ruby/aprc  ~/.aprc

# git
ln -s $HOME/.dotfiles/git/gitignore ~/.gitignore
ln -s $HOME/.dotfiles/git/gitconfig ~/.gitconfig


# zsh
ln -s $HOME/.dotfiles/zsh/prezto ~/.zprezto
ln -s $HOME/.dotfiles/zsh/zshrc ~/.zshrc

RUNCONS=$(ls $HOME/.dotfiles/zsh/prezto/runcoms/z*)
for runcon in $RUNCONS
do
  target=$(basename $runcon)
  target=".$target"
  cp $runcon ~/$target
done
ln -nfs $HOME/.dotfiles/zsh/prezto-override/zpreztorc ~/.zpreztorc
chsh -s /bin/zsh

# tmux
ln -s $HOME/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# vimify
ln -s $HOME/.dotfiles/vimify/inputrc ~/.inputrc
ln -s $HOME/.dotfiles/vimify/editrc  ~/.editrc
