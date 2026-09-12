# termux-deepseek-harness

> 🚀 在 Android Termux 环境下一键安装与无缝运行 [DeepSeek Harness (`@deepseek-ai/dsh`)](https://github.com/deepseek-ai/deepseek-harness) 的适配脚本。

---

## 📖 简介 (Overview)

DeepSeek Harness 是 DeepSeek 官方出品的开源 AI 交互工具。在 Android Termux 环境下直接安装使用时，通常会遇到以下两类问题：

1. **运行时崩溃**：`dsh` 基于 Cordis 加载机制与 HMR，依赖 Node.js 内部私有 API，若缺少 `--expose-internals` 标志，启动时将直接抛错退出。
2. **Web 模式打开报错**：执行 `dsh web` 时，内部自带的 `xdg-open` 找不到 X11/桌面图形浏览器导致命令失败退出。

本项目脚本提供了**一键依赖安装、npm 全局安装、Node 运行参数注入以及系统浏览器调用桥接（`termux-open`）**，让您在手机 Termux 上即可轻松畅享 DeepSeek Harness。

---

## ⚡ 快速开始 (Quick Start)

### 1. 一键安装 (One-click Install)

在 Termux 终端中执行以下命令（可直接克隆执行或一键执行脚本）：

```bash
git clone https://github.com/NXETCP/termux-deepseek-harness.git
cd termux-deepseek-harness
chmod +x install-deepseek-harness.sh
./install-deepseek-harness.sh
```

或使用 curl / wget 快速运行：

```bash
curl -fsSL https://raw.githubusercontent.com/NXETCP/termux-deepseek-harness/master/install-deepseek-harness.sh | bash
```

### 2. 启动与使用 (Usage)

#### 终端命令行交互模式
直接在终端与 DeepSeek 交互：
```bash
dsh
```

#### Web 网页界面模式
启动内置 Web 交互页面：
```bash
dsh web
```
> **提示**：脚本已打好 Termux 浏览器桥接补丁，执行后会自动唤起手机系统默认浏览器；终端也会同步打印带安全 Token 的访问链接（如 `http://127.0.0.1:3080/?token=...`）。

若无需自动弹出浏览器，或需自定义端口：
```bash
# 不自动弹出浏览器，指定端口 8080
dsh web --no-open --port 8080
```

---

## 🛠️ 脚本所做的修复与优化 (Patches Applied)

1. **环境依赖检查与安装**：
   - 自动检测并安装 `nodejs-lts`（或 `nodejs`）、`git`、`termux-tools` 等必备软件包。
2. **全局安装 `@deepseek-ai/dsh`**：
   - 通过 npm 全局安装官方核心包。
3. **运行时标志注入 (`--expose-internals`)**：
   - 为全局 `dsh` 可执行命令注入 `node --expose-internals`，解决插件加载器与 Cordis 框架底层依赖报错。
4. **Termux 浏览器桥接适配**：
   - 自动检测并接管 `dsh` 内置的 `open/xdg-open` 脚本，桥接转发至 `termux-open`，使得手机端可无缝唤起系统浏览器访问 Web 页面。

---

## 📄 开源许可证 (License)

本项目基于 [MIT License](LICENSE) 开源。
DeepSeek Harness 归其官方团队 [DeepSeek](https://github.com/deepseek-ai) 所有。
