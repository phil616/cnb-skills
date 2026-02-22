#!/bin/bash
set -e

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# 同步配置：格式为 "远程仓库URL|远程目录|本地目标目录"
SYNC_CONFIGS=(
    "https://cnb.cool/cnb/docs|docs/build|.claude/skills/云原生构建/references"
    "https://cnb.cool/cnb/docs|docs/workspaces|.claude/skills/云原生开发/references"
)

# 获取脚本所在目录作为仓库根目录
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 缓存已克隆的仓库，避免同一仓库重复克隆
declare -A CLONED_REPOS

for config in "${SYNC_CONFIGS[@]}"; do
    IFS='|' read -r REMOTE_URL REMOTE_DIR LOCAL_DIR <<< "$config"

    echo ""
    echo "▶ 同步: $REMOTE_URL/$REMOTE_DIR"
    echo "     -> $LOCAL_DIR"

    # 用 URL 的 hash 作为克隆目录名，相同仓库复用
    URL_HASH=$(printf '%s' "$REMOTE_URL" | md5sum | cut -d' ' -f1)
    CLONE_DIR="$TEMP_DIR/$URL_HASH"

    if [[ -z "${CLONED_REPOS[$URL_HASH]+_}" ]]; then
        echo "  [1/2] 克隆仓库..."
        git clone \
            --depth 1 \
            --filter=blob:none \
            --sparse \
            --quiet \
            "$REMOTE_URL" \
            "$CLONE_DIR"
        CLONED_REPOS[$URL_HASH]="$CLONE_DIR"
    else
        echo "  [1/2] 复用已克隆仓库"
    fi

    # 追加 sparse-checkout 路径（支持同一仓库多个目录）
    echo "  [2/2] 拉取目录: $REMOTE_DIR"
    git -C "$CLONE_DIR" sparse-checkout add "$REMOTE_DIR" 2>/dev/null || \
    git -C "$CLONE_DIR" sparse-checkout set "$REMOTE_DIR"

    SOURCE="$CLONE_DIR/$REMOTE_DIR"

    if [[ ! -d "$SOURCE" ]]; then
        echo "  ✗ 错误：远程目录不存在：$REMOTE_DIR" >&2
        exit 1
    fi

    TARGET="$REPO_ROOT/$LOCAL_DIR"
    mkdir -p "$TARGET"
    rm -rf "${TARGET:?}"/*
    cp -r "$SOURCE/." "$TARGET/"

    echo "  ✓ 完成"
done

echo ""
echo "所有同步完成"