---
name: CNB云原生开发工具
description: 使用CNB云原生开发来进行远程开发环境的配置和管理，支持WebIDE和本地IDE连接。
---

# CNB云原生开发工具（vscode）

云原生开发是基于云原生构建的远程开发解决方案，支持通过 WebIDE、VSCode 客户端、Cursor 客户端及 JetBrains 客户端连接远程开发环境进行远程开发。该工具用于配置和管理云原生开发环境。

## 功能

### 基础介绍

云原生开发具有声明式（基于 Dockerfile）、快速启动、按需使用（闲时自动回收）等特点。支持在仓库分支页面一键创建开发环境。

详细文档： [云原生开发介绍](./references/intro.md)

### 核心机制

- **推荐用法**：建议创建独立开发分支，编码提交后发起合并请求并自动回收环境。保持一个分支只干一件事。
- **回收机制**：支持自动回收（无操作/无心跳 10 分钟）、最大保持时间（18小时）以及“环境不过夜”策略（凌晨强制回收）。

详细文档：
- [云原生开发推荐用法](./references/working-principle.md)
- [远程开发工作区回收机制](./references/workspace-recycling.md)

### 默认开发环境

默认环境镜像为 `cnbcool/default-dev-env:latest`，内置了常用的开发工具（git, vim, curl 等）和 VSCode 插件（copilot, git-graph 等）。

详细文档： [默认开发环境](./references/default-dev-env.md)

### 自定义开发环境

支持多种方式自定义开发环境：
1.  **指定镜像**：在 `.cnb.yml` 中通过 `image` 指定。
2.  **Dockerfile**：在仓库根目录创建 `.ide/Dockerfile` 进行定制。
3.  **组合方式**：同时自定义启动流程和 Dockerfile。

详细文档： [自定义开发环境](./references/custom-dev-env.md)

### 自定义环境创建流程

通过 `.cnb.yml` 配置文件，可以：
- 自定义启动事件（如 `vscode`, `branch.create`）。
- 自定义资源规格（CPU/内存）。
- 自定义可用时机（使用 `vscode:go` 延迟进入）。
- 定义环境销毁前执行的任务（`endStages`）。

详细文档： [自定义环境创建流程](./references/custom-dev-pipeline.md)

### 容器模式

支持两种启动模式：
- **单容器模式**（推荐）：开发环境和代码服务在同一容器。
- **双容器模式**：开发环境未安装 `code-server` 时，自动启动额外的代码服务容器，两者工作区互通。

详细文档： [单/双容器模式](./references/double-container.md)

### 客户端支持

- **VSCode/Cursor**：默认支持。自定义环境需安装 `openssh-server`。支持解决窗口覆盖问题。
- **JetBrains**：通过 JetBrains Gateway 连接。需在 Dockerfile 中安装 `openssh-server` 和相应的 IDE Server。

详细文档：
- [VSCode/Cursor 客户端](./references/vscode-likes.md)
- [Jetbrains 客户端](./references/jetbrains.md)

### 数据保护与漫游

- **代码备份**：环境销毁时自动 `git stash` 备份未提交代码；每 5 分钟定时备份。
- **文件漫游**：支持非工作区文件（如 `.gitconfig`, WebIDE 配置, `~/.cnb` 目录）在环境重建时自动恢复。

详细文档： [代码备份和文件漫游](./references/file-keeper.md)

### 安全与网络

- **SSH 指纹验证**：提供 SSH 密钥指纹以供验证连接安全性。
- **端口预览**：支持通过 WebIDE 端口映射或 VSCode 端口转发预览业务服务。

详细文档：
- [云原生开发 SSH 密钥指纹验证](./references/fingerprint.md)
- [业务端口预览](./references/business-preview.md)

### 其他配置与技巧

- **自定义启动按钮**：通过 `.cnb/settings.yml` 自定义按钮名称、描述及规格。
- **使用技巧**：解决剪贴板授权、快捷键冲突、VSCode 配置漫游及扩展安装（支持 `open-vsx` 和 `vsix` 文件）。
- **常见问题**：如安装指定版本的 `code-server`。

详细文档：
- [自定义云原生开发启动按钮](./references/custom-dev-button.md)
- [使用技巧](./references/usage-tips.md)
- [常见问题解答](./references/question.md)
