---
name: CNB云原生构建工具
description: 使用CNB云原生构建来进行CICD相关脚本的编写，让项目能够利用CNB云原生构建的能力进行DevOps和CICD。
---

# CNB云原生构建工具（build）

CNB云原生构建平台是CNB仓库的自动CICD能力，类似Github Actions，允许项目通过`.cnb.yml`配置文件来进行CICD。该工具用于为项目添加CICD相关配置和脚本编写。

## 功能

### 基础介绍

云原生构建基于 Docker 生态，通过声明式语法、与环境代码同源管理、资源池化等特点助力软件构建。其介绍了声明式构建环境、缓存、插件等，还支持高性能，如按需获取 CPU 资源、快速克隆大仓库及实现缓存读写并发无冲突 。

详细文档： [云原生构建介绍](./references/intro.md)

### 快速开始

介绍如何使用“云原生构建”创建和配置流水线，从创建仓库、编写 `.cnb.yml` 配置文件、查看构建详情到处理 Pull Request 流水线检测的全过程。

详细文档： [快速开始](./references/quick-start.md)

### 配置文件

`.cnb.yml` 是云原生构建的配置文件，用于定义仓库事件触发构建任务的条件和步骤。采用 YAML 格式，支持锚点复用和跨文件配置导入（include），提供语法检查和自动补全功能。支持通过简化配置（如 YAML 高级语法）减少重复。

详细文档： 
- [配置文件](./references/configuration.md)
- [简化配置文件](./references/simplify-configuration.md)

### 流水线语法

详细介绍了流水线语法，包括 Pipeline、Stage 和 Job 的基本概念及其配置参数。涵盖了资源定义、环境变量、镜像指定、服务声明、条件触发（if/ifModify）、重试机制和锁机制等。

详细文档： [流水线语法](./references/grammar.md)

### 构建环境

构建环境决定了任务执行时的可用软件和工具。CNB 使用 Docker 容器作为构建环境，支持指定已有镜像或通过 Dockerfile 构建临时镜像。构建任务会被下发到各构建集群中执行，支持选择不同架构（amd64/arm64/gpu）的构建集群。

详细文档： 
- [构建环境](./references/build-env.md)
- [构建集群](./references/saas/build-node.md)

### 环境变量

支持声明（env）、导入（imports）和导出（exports）环境变量。系统提供了一系列内置只读环境变量（如 Commit 信息、PR 信息、仓库信息等）。支持在脚本和配置中进行变量替换。

详细文档： 
- [环境变量](./references/env.md)
- [默认环境变量](./references/build-in-env.md)

### 触发规则与事件

定义了流水线被触发的规则。支持多种事件触发：
- **Git 事件**：push, tag_push, branch.create/delete, pull_request 等。
- **定时任务**：通过 crontab 表达式定时触发。
- **手动触发**：通过 Web 页面按钮（web_trigger）或 API（api_trigger）触发。
- **跳过机制**：支持通过 Commit Message 或 Push Options 跳过流水线。

详细文档： 
- [构建触发规则](./references/trigger-rule.md)
- [定时任务](./references/crontab.md)
- [手动触发流水线](./references/web-trigger.md)
- [跳过流水线](./references/skip-pipeline.md)

### 流水线缓存

通过缓存依赖和中间产物（如 node_modules），减少构建时间。支持节点本地缓存（Volumes）和跨节点 Docker 镜像缓存。

详细文档： [流水线缓存](./references/pipeline-cache.md)

### 内置任务

CNB 提供了一系列内置任务，方便开发者快速实现常见功能，如：
- **Docker**: 镜像缓存构建。
- **CNB**: 流水线协作（await/resolve）、触发子流水线（apply/trigger）、读取文件。
- **Git**: 自动合并 PR、更新 Issue、管理评审人、发布 Release、更新 PR 信息。
- **Testing**: 覆盖率报告。
- **Artifact**: 制品管理。
- **TAPD**: 关联状态更新。

详细文档： [内置任务](./references/internal-steps/README.md)

### 插件系统

插件是 Docker 镜像，用于扩展流水线能力。支持从零开发插件（Bash/Dockerfile）、参数传递、测试及发布到插件市场。

详细文档： 
- [插件制作](./references/create-plugin.md)
- [贡献插件](./references/contribute-plugin.md)

### 部署与运维

支持自定义部署流程，包括部署环境配置、审批流程、部署按钮权限控制等。提供登录调试功能，允许在构建过程中或构建结束后进入容器调试。支持配置流水线和任务的超时策略。

详细文档： 
- [自定义部署流程](./references/deploy.md)
- [登录调试](./references/login-debug.md)
- [超时策略](./references/timeout.md)

### 文件引用与权限

支持跨仓库引用配置文件（include/imports），并提供权限控制机制（allow_slugs, allow_events 等）防止敏感信息泄漏。角色权限对齐代码仓库权限模型。

详细文档： 
- [文件引用](./references/file-reference.md)
- [权限说明](./references/permission.md)

### 迁移指南

提供了从 GitHub Actions 迁移到 CNB 的详细对比和指南，涵盖工作流配置、触发规则、Runner、构建环境、缓存等方面的差异。

详细文档： [从 GitHub Actions 迁移到 CNB](./references/migrate-to-cnb/migrate-from-github-actions.md)

### 最佳实践

提供常见场景的配置示例：
- **Monorepo**: 按需构建。
- **Docker**: 构建并上传镜像到制品库。
- **通知**: PR/Issue 状态变更通知到企业微信群。

详细文档： 
- [Monorepo按需构建](./references/showcase/1.monorepo.md)
- [构建Docker镜像并上传](./references/showcase/2.docker-build-and-push-to-cnb-artifact.md)
- [PR通知到企业微信群](./references/showcase/3.pr-notice-group.md)
- [ISSUE通知到企业微信群](./references/showcase/issue-notice-group.md)
