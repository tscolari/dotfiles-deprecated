#!/bin/bash

cd $(dirname $0)
DOTFILES_FOLDER=$(pwd)

PPAS="
  ppa:aacebedo/fasd
  ppa:fkrull/deadsnakes
  ppa:git-core/ppa
  ppa:neovim-ppa/stable
  ppa:noobslab/icons
  ppa:noobslab/themes
  ppa:numix/ppa
  ppa:pi-rho/dev
  ppa:snwh/pulp
  ppa:tista/adapta
  ppa:tmate.io/archive
"

PACKAGES="
  ack-grep
  adapta-gtk-theme
  build-essential
  clipit
  cmake
  curl
  direnv
  docker.io
  exuberant-ctags
  fasd
  flatabulous-theme
  git
  gnome-tweak-tool
  hfsprogs
  jq
  libcurl4-openssl-dev
  libffi-dev
  libreadline-dev
  libsqlite3-dev
  libssl-dev
  libxml2
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  neovim
  nodejs
  numix-gtk-theme
  openssl
  paper-cursor-theme
  paper-gtk-theme
  paper-icon-theme
  pinentry-curses
  python3-pip
  python3.6
  ruby
  silversearcher-ag
  sqlite3
  tig
  tmate
  tmux-next
  tree
  ultra-flat-icons
  vim
  virtualbox
  virtualbox-guest-additions-iso
  virtualbox-guest-utils
  xclip
  xsel
  zlib1g-dev
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

  install_vagrant
  install_go
  install_zsh
  install_git
  install_psql
  install_ruby
  install_inputrc
  install_tmux
  install_vimlocal
  install_gnome_themes
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
  sudo apt install -y postgresql-9.6 libpq-dev postgresql-contrib-9.6
}

function install_ruby {
  rm -rf $HOME/.gemrc
  rm -rf $HOME/.pryrc
  ln -s $DOTFILES_FOLDER/ruby/gemrc $HOME/.gemrc
  ln -s $DOTFILES_FOLDER/ruby/pryrc $HOME/.pryrc

  curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
  curl -sSL https://get.rvm.io | bash
  rvm get stable --auto-dotfiles
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
  sudo ln -s $(which tmux-next) /usr/local/bin/tmux
}

function install_vagrant {
  wget -O /tmp/vagrant.deb https://releases.hashicorp.com/vagrant/1.9.4/vagrant_1.9.4_x86_64.deb
  sudo dpkg -i /tmp/vagrant.deb
  rm /tmp/vagrant.deb
}

function install_vimlocal {
  rm -rf $HOME/.vimrc.local
  ln -s $DOTFILES_FOLDER/vim/vimrc.local $HOME/.vimrc.local
}

function install_gnome_themes {
  install_gnome_theme https://github.com/mgyugcha/copernico-theme
  install_gnome_theme https://github.com/horst3180/Arc-theme
  install_gnome_theme https://github.com/luisvilches/uranus-ligth-theme-gnome-shell-3.20
}

function install_gnome_theme {
  local repo=$1
  local folder_name=$(basename $1)

  if [ ! -d ~/.themes/$folder_name ]
  then
    git clone $repo ~/.themes/$folder_name
  else
    (
      cd ~/.themes/$folder_name
      git pull origin master
    )
  fi
}

main
