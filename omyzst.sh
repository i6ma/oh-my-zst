#!/usr/bin/env bash

set -e

ZSHom="oh-my-zsh"
ZSHog="https://github.com/robbyrussell/${ZSHom}.git"
ZSHoz="${ZSHom}.tar.gz"
ZSHou="${HOME}/.${ZSHom}"
ZSHrc="${HOME}/.zshrc"
ZSHrb="${ZSHrc}.pre-${ZSHom}"
ZSHrt="${ZSHou}/templates/zshrc.zsh-template"



function gclone() {
  umask g-w,o-w
  if [[ ! -d "${ZSHom}" ]]; then
    git clone --depth=1 "${ZSHog}" "${ZSHom}"
  else
    cd "${ZSHom}"
    git reset --hard origin/master
    git pull
    cd -
  fi
}


function gtargz() {
  if [[ ! -f "${ZSHoz}" ]]; then
    gclone
    mv "${ZSHom}" ".${ZSHom}"
    tar -zcf "${ZSHoz}" --exclude .git ".${ZSHom}"
    mv ".${ZSHom}" "${ZSHom}"
  fi
}


function install() {
  if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh not installed"
    exit
  fi
  if [[ -d "${ZSHou}" ]]; then
    echo "Oh My Zsh already installed"
    exit
  fi
  tar -xf "${ZSHoz}" -C "${HOME}"
}


function mzshrc() {
  if [[ -f "${ZSHrc}" ]] || [[ -h "${ZSHrc}" ]]; then
    echo "Back up ${ZSHrc} to ${ZSHrb}"
    mv "${ZSHrc}" "${ZSHrb}"
  fi
  cp  "${ZSHrt}" "${ZSHrc}"
}


function chtozsh() {
  if [[ ${SHELL##*/} != "zsh" ]]; then
    if hash chsh >/dev/null 2>&1; then
      chsh -s $(grep /zsh$ /etc/shells | tail -1)
    else
      echo "System does not have chsh. Please manually change default shell to zsh!"
    fi
    zsh -l
  fi
}



cd "$(dirname "$0")"
gtargz
install
cd -
mzshrc
chtozsh

