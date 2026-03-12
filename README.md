# wayland-screenshot-script

> ⚠️ **免责声明**: 本项目由 LLM (Claude Sonnet 4.6) 自动生成，作者仅在自己的环境中进行过基本使用测试，未在其他环境中进行充分测试。使用本脚本产生的任何问题由使用者自行承担。

一个便捷的截图脚本，支持多种截图模式、自动保存、剪贴板复制和图片编辑。

## 为什么需要这个工具

在日常使用 Linux 桌面环境时，我需要一个简单高效的截图工作流：

1. **快速截图** - 能够快速进行选区、窗口或全屏截图
2. **自动保存** - 不需要每次手动选择保存位置，统一管理到指定目录
3. **即时分享** - 截图后直接复制到剪贴板，可以立即粘贴到聊天应用、邮件或文档中
4. **后续编辑** - 需要标注或编辑时，自动打开图片编辑工具

虽然 `gnome-screenshot` 和 `ksnip` 都很强大，但单独使用它们都无法一次性完成以上所有步骤。这个脚本将它们整合在一起，提供一个完整的一站式截图解决方案。

## 功能特性

- 🖼️ **多种截图模式**：支持选区截图、窗口截图、全屏截图
- 💾 **自动保存**：截图自动保存到 `~/Pictures/Screenshots/` 目录
- 📋 **剪贴板复制**：截图后自动复制到剪贴板，便于粘贴分享
- ✏️ **图片编辑**：自动使用 ksnip 打开截图进行编辑
- 🔄 **不重名命名**：使用毫秒级时间戳，避免文件覆盖
- ✅ **依赖检测**：自动检查所需工具是否安装

## 系统要求

- Linux 系统（支持 Wayland 和 X11）
- Bash shell
- 必需工具：
  - `gnome-screenshot` - 截图工具
  - `ksnip` - 图片编辑工具
  - `wl-copy` 或 `xclip` - 剪贴板工具

## 安装

### 1. 安装依赖

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install gnome-screenshot ksnip wl-clipboard
# 或者使用 xclip
sudo apt install gnome-screenshot ksnip xclip
```

**Fedora:**
```bash
sudo dnf install gnome-screenshot ksnip wl-clipboard
```

**Arch Linux:**
```bash
sudo pacman -S gnome-screenshot ksnip wl-clipboard
```

### 2. 下载脚本

```bash
# 克隆仓库
git clone https://github.com/liflux/wayland-screenshot-script.git
cd wayland-screenshot-script

# 赋予执行权限
chmod +x mysnap.sh
```

## 使用方法

### 命令行参数模式

```bash
# 选区截图（默认）
./mysnap.sh -a

# 窗口截图
./mysnap.sh -w

# 全屏截图
./mysnap.sh -f

# 显示帮助
./mysnap.sh -h
```

### 交互式菜单模式

```bash
./mysnap.sh
```

会显示菜单让选择截图模式：
1. 选区截图
2. 窗口截图
3. 全屏截图
4. 退出

### 设置键盘快捷键

**Ubuntu 24.04:**

1. 打开 **设置** → **键盘**
2. 点击 **自定义快捷键**
3. 点击 **+** 添加新快捷键：
   - 名称：`我的截图工具`
   - 命令：`/path/to/mysnap.sh -a`
   - 快捷键：`Ctrl+Alt+Shift+S`

## 文件命名

截图文件按以下格式命名：
```
screenshot-YYYYMMDD-HHMMSS-XXX.png
```

示例：
```
screenshot-20260312-143052-789.png
```

使用毫秒级时间戳确保快速连续截图时不会重名。

## 项目结构

```
wayland-screenshot-script/
├── mysnap.sh           # 主脚本文件
├── README.md           # 项目文档
├── LICENSE             # 许可证
└── 说明文件.md         # 中文说明
```

## 工作流程

1. 检查依赖工具是否安装
2. 生成唯一的文件名（含时间戳）
3. 使用 gnome-screenshot 截图并保存
4. 使用 wl-copy/xclip 复制到剪贴板
5. 使用 ksnip 打开图片进行编辑

## 故障排除

### 剪贴板复制不工作

确保安装了剪贴板工具：
```bash
# Wayland 系统
sudo apt install wl-clipboard

# X11 系统
sudo apt install xclip
```

### ksnip 未打开

检查 ksnip 是否正确安装：
```bash
which ksnip
ksnip --version
```

### 截图失败

确保 gnome-screenshot 可用：
```bash
which gnome-screenshot
gnome-screenshot --help
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 作者

本项目由 [liflux](https://github.com/liflux) 创建，代码由 [Claude Sonnet 4.6](https://www.anthropic.com/claude) 自动生成。

## 测试状态

- ✅ 在作者环境 (Ubuntu 24.04) 中基本功能可用
- ⚠️ 未在其他 Linux 发行版中测试
- ⚠️ 未在不同桌面环境中测试
- ⚠️ 未进行充分的边缘情况测试

## 相关项目

- [gnome-screenshot](https://gitlab.gnome.org/GNOME/gnome-screenshot) - GNOME 截图工具
- [ksnip](https://github.com/ksnip/ksnip) - 跨平台截图工具
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) - Wayland 剪贴板工具
