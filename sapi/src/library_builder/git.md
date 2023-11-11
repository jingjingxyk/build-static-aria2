
git gc --prune=now


git shortlog -s ${1-} |
cut -b8- |
sort | uniq



# 删除子模块
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

```
git log --pretty=oneline

git stash list

git remote show origin
git branch -a
git branch -r
git remote prune origin
git remote prune origin --dry-run


git gc --prune=now
