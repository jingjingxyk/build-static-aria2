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

# 3. 加载环境
# source /etc/zshrc  # 如果用 zsh
# 或
# source ~/.bash_profile  # 如果用 bash

mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
substituters = https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org
experimental-features = nix-command flakes
connect-timeout = 10
download-attempts = 5
stalled-download-timeout = 30
EOF

nix config show
nix config show trusted-users
