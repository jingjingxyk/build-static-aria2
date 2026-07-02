#!/usr/bin/env bash

set -exu
__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
__PROJECT__=$(
  cd ${__DIR__}/../
  pwd
)
shopt -s expand_aliases
cd ${__PROJECT__}

mkdir -p ${__PROJECT__}/var/
cd ${__PROJECT__}/


if [ ! -f runtime/aria2c/aria2c ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-aria2-runtime.sh?raw=ture | bash
fi

if [ ! -f runtime/ffmpeg/bin/ffmpeg ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-ffmpeg-runtime.sh?raw=ture | bash
fi

if [ ! -f runtime/privoxy/sbin/privoxy ]; then
  curl -fSL https://gitee.com/jingjingxyk/swoole-cli/raw/new_dev/setup-privoxy-runtime.sh?raw=ture | bash -s -- --mirror china
fi

export PATH="${__PROJECT__}/runtime/aria2c/:${__PROJECT__}/runtime/ffmpeg/bin/:$PATH"
which aria2c



# 安装 uv
# curl -LsSf https://astral.sh/uv/install.sh | sh
# pip install uv
source $HOME/.local/bin/env
uv --version
export UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
# uv init my-project

# export UV_PYTHON_INSTALL_DIR="/opt/uv-python"
# uv python install 3.13
uv python dir
# uv python list
# uv python find 3.13
uv python find

uv python find 3.14
PYTHON_BIN_PATH=$(uv python find 3.14)
PYTHON_BIN_PATH=${PYTHON_BIN_PATH:0:-10}
export PATH="$PYTHON_BIN_PATH":$PATH;
uv tool install "yt-dlp[default,curl-cffi]"

# export UV_PYTHON="/usr/bin/python3.12"
uv run python --version

# uv add yt-dlp

# uvx yt-dlp
# pip install "yt-dlp[default,curl-cffi]"

# 使用 uv 的全局安装功能 (如果 uv 版本支持)
# uv tool install yt-dlp

# 或者使用 pipx (推荐的全局工具管理方式)
# pipx install yt-dlp

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
REFERER="https://www.douyin.com/?recommend=1"
PROXY=http://127.0.0.1:8118

uv run --python 3.13 yt-dlp \
       -P "${HOME}/Downloads/video" \
       --user-agent "$UA"  \
       --referer "$REFERER" \
       --proxy "$PROXY"     \
        --downloader aria2c \
        --downloader-args "aria2c: -c -x 8 -s 16 -k 10M --max-tries=30 --retry-wait=15 --header='User-Agent: ${UA}' --header='referer: ${REFERER}' --all-proxy=${PROXY} " \
        "https://www.douyin.com/jingxuan?modal_id=7623333375064267950"
