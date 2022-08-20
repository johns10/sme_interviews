#!/bin/sh

CURRENT_DIRECTORY=$(dirname "$0")
SYS_ARCH=$(uname -m)

info() {
  # shellcheck disable=SC2059
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success() {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n\n"
  # exit
}

# This allows the script to be run from the projects root folder or the scripts folder in order
# to give the script access to the mix tasks needed to install the minio server and client
if [ "${CURRENT_DIRECTORY}" = "." ]; then
  cd ..
fi

if [ "${SYS_ARCH}" = "arm64" ]; then
  info "System architecture: ${SYS_ARCH}"

  info "Installing latest version of minio server for ${SYS_ARCH}"
  mix minio_server.download --arch darwin-arm64 --version latest
  success "Installed latest version of minio server for ${SYS_ARCH}"

  info "Installing latest version of minio client for ${SYS_ARCH}"
  mix minio_server.download --client --arch darwin-arm64 --version latest
  success "Installed latest version of minio client for ${SYS_ARCH}"
elif [ "${SYS_ARCH}" = "x86_64" ]; then
  info "System architecture: ${SYS_ARCH}"

  info "Installing latest version of minio server for ${SYS_ARCH}"
  mix minio_server.download --arch darwin-amd64 --version latest
  success "Installed latest version of minio server for ${SYS_ARCH}"

  info "Installing latest version of minio client for ${SYS_ARCH}"
  mix minio_server.download --client --arch darwin-amd64 --version latest
  success "Installed latest version of minio client for ${SYS_ARCH}"
else
  fail "Unsupported System Architecture"
fi