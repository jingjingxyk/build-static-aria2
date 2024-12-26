```bash

git gc --prune=now


git shortlog -s ${1-} |
cut -b8- |
sort | uniq

```

## 添加子模块

```shell


 git submodule add https://github.com/swoole/swoole-src.git ext/swoole



```

## 检出

```shell

git submodule update --init -f

# git submodule update --init --force --remote


```

## 删除子模块

```bash

git submodule deinit ext/swoole

git submodule deinit -f ext/swoole

rm -rf .git/modules/ext/swoole/

git rm -rf ext/swoole/

```

## 创建空的新分支

```bash
git checkout  --orphan  static-php-cli-next

git rm -rf .

```

## 清理未跟踪的文件 谨慎使用

```bash
git clean -df
```

```bash
git clone --single-branch --depth=1 https://github.com/jingjingxyk/swoole-cli.git


git fsck --lost-found  # 查看记录
```

## 合并时不保留commit 信息

```bash
git merge --squash branch_name

```

## 当前分支 hash

```bash
git rev-parse HEAD

```

```bash

git config core.ignorecase false # 设置 Git 在 Windows 上也区分大小写

git reflog # 查看所有的提交历史
git reset --hard c761f5c # 回退到指定的版本

```

## 节省网络流量

```bash

git clone --recurse-submodules --single-branch -b main --progress --depth=1


git log --pretty=oneline

git stash list

git remote show origin
git branch -a
git branch -r
git remote prune origin
git remote prune origin --dry-run


git gc --prune=now



```

## 单个文件回滚

```bash
git log

git checkout commit_id filename



```

## git 恢复被删除的整个文件夹

```shell

git log --oneline -- experimental-features/v3/rules/example/
git checkout commit_id -- experimental-features/v3/rules/example/

```

## git commits 出现累积叠加 解决办法

```bash

git merge dev --squash

git branch -D dev
git checkout -b dev

```

## 创建新的空分支

```bash

git checkout -b --orphan  new_branch

git rm -rf .

```

## 获取提交时间

```bash

 # 获得提交时间
 TZ=UTC git show --date=format-local:%Y%m%d%k%M%S

```

## 合并两个无关的仓库

```bash
git merge  --allow-unrelated-histories
```

## 查看提交日志

```bash

git log --oneline

```

```bash

GITVERSION="git --git-dir $(pwd)/.git rev-parse --short HEAD"
GITTAG="git --git-dir $(pwd)/.git describe --all --always --dirty"
GITBRANCH="git --git-dir $(pwd)/.git name-rev --name-only HEAD"


GIT_COMMIT:=$(git describe --dirty --always)
GIT_BRANCH:=$(git rev-parse --abbrev-ref HEAD -- | head -1)
DATE:=$(date +"%Y-%m-%d")

git config --global --add safe.directory "$GITHUB_WORKSPACE"

```

## 设置 分支 跟踪

```bash

git branch --set-upstream-to=origin/main main
```

## 查看当前分支

```shell

git rev-parse --abbrev-ref HEAD

git log --pretty=%ad-%h --date=format:'%Y%m%d%H%M' -n 1 | cat


TZ=UTC git show --quiet --date='format-local:%Y%m%dT%H%M%SZ' --format="%cd"

```

## windows git 配置 代理

```shell

# download socat
curl.exe -fSLo socat-v1.8.0.1-cygwin-x64.zip https://github.com/jingjingxyk/build-static-socat/releases/download/v2.2.1/socat-v1.8.0.1-cygwin-x64.zip

curl.exe -fSLo socat-v1.8.0.1-cygwin-x64.zip  https://php-cli.jingjingxyk.com/socat-v1.8.0.1-cygwin-x64.zip


curl.exe -fSLo cacert.pem https://curl.se/ca/cacert.pem

```

```

.\socat -d -d TCP4-LISTEN:8016,reuseaddr,fork ssl:http-proxy.xiaoshuogeng.com:8017,verify=1,snihost=http-proxy.xiaoshuogeng.com,commonname=http-proxy.xiaoshuogeng.com,openssl-min-proto-version=TLS1.3,openssl-max-proto-version=TLS1.3,verify=1,cafile=cacert.pem


```

```text
vi  ~\.ssh\config


Host github.com
  Hostname github.com
  Port 22
  PreferredAuthentications publickey
  StrictHostKeyChecking no
  IdentityFile  /c/Users/admin/.ssh/github-ssh-key-id-rsa
  # ProxyCommand nc -X 5 -x localhost:2000 %h %p
  # ProxyCommand socat - socks4a:localhost:%h:%p,socksport=2000
  ProxyCommand  "C:\Users\admin\socat-v1.8.0.1-cygwin-x64\socat-v1.8.0.1-cygwin-x64\socat" - proxy:localhost:%h:%p,proxyport=8016

````
