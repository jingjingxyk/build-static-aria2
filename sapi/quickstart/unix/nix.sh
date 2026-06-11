#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}


curl -L https://nixos.org/nix/install | sh

# for macos 12
# curl -L https://releases.nixos.org/nix/nix-2.24.10/install | sh
