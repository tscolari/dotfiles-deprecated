#!/bin/bash

cd $(dirname $0)
DOTFILES_FOLDER=$(pwd)

PPAS="
  ppa:git-core/ppa
  ppa:neovim-ppa/stable
  ppa:fkrull/deadsnakes
  ppa:pi-rho/dev
  ppa:tmate.io/archive
  ppa:aacebedo/fasd
  ppa:noobslab/themes
  ppa:noobslab/icons
"

PACKAGES="
  build-essential
  openssl
  silversearcher-ag
  git
  neovim
  exuberant-ctags
  python3.6
  ruby
  python3-pip
  docker.io
  tmux-next
  vim
  tree
  curl
  tmate
  ack-grep
  direnv
  tig
  jq
  xclip
  xsel
  fasd
  virtualbox
  virtualbox-guest-additions-iso
  virtualbox-guest-utils
  gnome-tweak-tool
  hfsprogs
  libcurl4-openssl-dev
  libxml2
  libssl-dev
  libxml2-dev
  pinentry-curses
  cmake
  flatabulous-theme
  ultra-flat-icons
  clipit
  zsh
"

GO_BINS="
  github.com/git-duet/git-duet/...
  github.com/jmhodges/jsonpp
"

function main {
	fetch_submodules

	pre_apt_get
	add_ppas
	apt_get_stuff

	install_go
	install_zsh
	install_git
	install_psql
	install_ruby
	install_inputrc
	install_tmux
	install_vimlocal
}

function fetch_submodules {
	git submodule update --init --recursive
}

function install_go {
  (
    cd /tmp
    wget https://godeb.s3.amazonaws.com/godeb-amd64.tar.gz
    tar xzf godeb-amd64.tar.gz
    ./godeb install || true
  )
}

function install_go_bins {
  for gobin in $GO_BINS
  do
    go get $gobin
  done
}

function pre_apt_get {
  sudo apt-get update
  sudo apt-get install -y \
     software-properties-common \
     ca-certificates
}

function add_ppas {
  for ppa in $PPAS
  do
    sudo add-apt-repository -y $ppa
  done
  sudo apt-get update
}

function apt_get_stuff {
  echo $PACKAGES
  for package in "$PACKAGES"
  do
    sudo apt-get install -y $package
  done
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

function install_psql {
	rm -rf $HOME/.psqlrc
	ln -s $DOTFILES_FOLDER/psqlrc $HOME/.psqlrc

	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > "/etc/apt/sources.list.d/pgdg.list"'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
	  sudo apt-key add -
	sudo apt update
	sudo apt install -y postgresql-9.4 libpq-dev
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

main
