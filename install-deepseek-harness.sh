#!/data/data/com.termux/files/usr/bin/sh
# ==============================================================================
# DeepSeek Harness (dsh) 安装与环境修复脚本
# 支持 Termux 及标准 Linux / macOS 环境
# ==============================================================================

set -eu

log_info() {
    printf "\033[1;34m[INFO]\033[0m %s\n" "$*"
}

log_warn() {
    printf "\033[1;33m[WARN]\033[0m %s\n" "$*"
}

log_error() {
    printf "\033[1;31m[ERROR]\033[0m %s\n" "$*" >&2
}

# 1. 检查 Node.js / npm
if ! command -v node >/dev/null 2>&1; then
    log_error "未检测到 Node.js，请先安装 Node.js (推荐 v18 及以上版本)"
    exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
    log_error "未检测到 npm，请先安装 npm"
    exit 1
fi

log_info "Node.js 版本: $(node -v)"
log_info "npm 版本: $(npm -v)"

# 2. 全局安装 @deepseek-ai/dsh
log_info "正在全局安装 @deepseek-ai/dsh (DeepSeek Harness CLI)..."
npm install -g @deepseek-ai/dsh

# 3. 针对 Termux 环境修复 shebang
if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
    log_info "检测到 Termux 环境，正在修复可执行文件 shebang..."
    if command -v termux-fix-shebang >/dev/null 2>&1; then
        DSH_BIN="$(command -v dsh || true)"
        if [ -n "$DSH_BIN" ]; then
            termux-fix-shebang "$DSH_BIN"
        fi
        PNPM_BIN="$(command -v pnpm || true)"
        if [ -n "$PNPM_BIN" ]; then
            termux-fix-shebang "$PNPM_BIN"
        fi
    else
        log_warn "未找到 termux-fix-shebang 命令，跳过修复"
    fi
fi

# 4. 验证安装
if command -v dsh >/dev/null 2>&1; then
    DSH_VER="$(dsh --version 2>&1 || echo 'unknown')"
    log_info "DeepSeek Harness 安装成功！当前版本: ${DSH_VER}"
    echo ""
    echo "使用示例:"
    echo "  dsh --help                    # 查看常用指令"
    echo "  dsh web                       # 启动 Web 交互界面"
    echo "  dsh --profile headless \"<task>\" # 执行单次指令任务"
else
    log_error "未在 PATH 中找到 dsh 命令，请检查 npm 全局 bin 路径是否已加入 PATH"
    exit 1
fi
