#!/bin/bash

cd $(dirname $0)
DOTFILES_FOLDER=$(pwd)

function main {
	fetch_submodules

	install_zsh
	install_git
	install_ctags
	install_psql
	install_ruby
	install_inputrc
	install_tmux
	install_vimlocal
	install_tools
}

function fetch_submodules {
	git submodule update --init --recursive
}

function install_zsh {
	runcoms_folder=$DOTFILES_FOLDER/zsh/prezto/runcoms
	for file in $(ls $runcoms_folder/z*)
	do
		target=$HOME/.$(basename ${file:t})
		rm -rf $target
		ln -s $file $target
	done

	rm -rf $HOME/.zshrc
	rm -rf $HOME/.zprezto
	rm -rf $HOME/.zpreztorc
	ln -s $DOTFILES_FOLDER/zsh/zshrc $HOME/.zshrc
	ln -s $DOTFILES_FOLDER/zsh/zpreztorc $HOME/.zpreztorc
	ln -s $DOTFILES_FOLDER/zsh/prezto $HOME/.zprezto
}

function install_git {
	rm -rf $HOME/.gitconfig
	rm -rf $HOME/.gitignore
	ln -s $DOTFILES_FOLDER/git/gitconfig $HOME/.gitconfig
	ln -s $DOTFILES_FOLDER/git/gitignore $HOME/.gitignore
}

function install_ctags {
	brew install ctags || sudo apt-get install exuberant-ctags || sudo emerge ctags
	rm -rf $HOME/.ctags
	ln -s $DOTFILES_FOLDER/ctags/ctags $HOME/.ctags
}

function install_psql {
	rm -rf $HOME/.psqlrc
	ln -s $DOTFILES_FOLDER/psqlrc $HOME/.psqlrc
}

function install_ruby {
	rm -rf $HOME/.gemrc
	rm -rf $HOME/.pryrc
	ln -s $DOTFILES_FOLDER/ruby/gemrc $HOME/.gemrc
	ln -s $DOTFILES_FOLDER/ruby/pryrc $HOME/.pryrc
}

function install_inputrc {
	rm -rf $HOME/.inputrc
	rm -rf $HOME/.editrc
	ln -s $DOTFILES_FOLDER/vimify/inputrc $HOME/.inputrc
	ln -s $DOTFILES_FOLDER/vimify/editrc $HOME/.editrc
}

function install_tmux {
	rm -rf $HOME/.tmux.conf
	rm -rf $HOME/.tmux
	ln -s $DOTFILES_FOLDER/tmux $HOME/.tmux
	ln -s $HOME/.tmux/tmux.conf $HOME/.tmux.conf
}

function install_vimlocal {
	rm -rf $HOME/.vimrc.local
	ln -s $DOTFILES_FOLDER/vim/vimrc.local $HOME/.vimrc.local
}

function install_tools {
	brew install the_silver_searcher || sudo emerge the_silver_searcher
	brew install tree || sudo emerge app-text/tree
	brew install htop || sudo emerge htop
	brew install jq || sudo emerge jq
	brew install direnv || sudo emerge direnv
	brew install tig || sudo emerge tig
	brew install ack || sudo emerge ack
}

main
