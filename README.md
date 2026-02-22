# CNB 文档Skills

## 仓库配置

目标路径

基础仓库： https://cnb.cool/cnb/docs

1. 引入云原生构建 - cnb-build
```
git remote add cnb-build https://cnb.cool/cnb/docs
git fetch cnb-build

git subtree add \
  --prefix=.claude/skills/云原生构建/references \
  cnb-build main:docs/build \
  --squash
```
2. 引入云原生开发 - cnb-workspaces

```
git remote add cnb-workspaces https://cnb.cool/cnb/docs
git fetch cnb-workspaces

git subtree add \
  --prefix=.claude/skills/云原生开发/references \
  cnb-workspaces main:docs/workspaces \
  --squash
```