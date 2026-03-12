#!/bin/bash

# 截图脚本 - 使用 gnome-screenshot
# 功能：截图、保存到指定目录、复制到剪贴板、用 ksnip 编辑

# 检查必要的工具是否安装
check_dependencies() {
    local missing_tools=()

    # 检查 gnome-screenshot
    if ! command -v gnome-screenshot &> /dev/null; then
        missing_tools+=("gnome-screenshot")
    fi

    # 检查 ksnip
    if ! command -v ksnip &> /dev/null; then
        missing_tools+=("ksnip")
    fi

    # 检查剪贴板工具（优先 wl-copy，其次是 xclip）
    if command -v wl-copy &> /dev/null; then
        CLIPBOARD_CMD="wl-copy"
    elif command -v xclip &> /dev/null; then
        CLIPBOARD_CMD="xclip"
    else
        missing_tools+=("wl-copy 或 xclip")
    fi

    # 如果有缺失的工具，显示错误信息并退出
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo "错误：以下工具未安装：" >&2
        for tool in "${missing_tools[@]}"; do
            echo "  - $tool" >&2
        done
        echo ""
        echo "请使用以下命令安装：" >&2
        echo "  sudo apt install gnome-screenshot ksnip wl-clipboard（或 xclip）" >&2
        exit 1
    fi
}

# 复制文件到剪贴板
copy_to_clipboard() {
    local file="$1"
    if [ "$CLIPBOARD_CMD" = "wl-copy" ]; then
        wl-copy < "$file"
    elif [ "$CLIPBOARD_CMD" = "xclip" ]; then
        xclip -selection clipboard -t image/png -i "$file"
    fi
}

# 在脚本开始时检查依赖
check_dependencies

# 配置
SAVE_DIR="$HOME/Pictures/Screenshots"

# 确保目录存在
mkdir -p "$SAVE_DIR"

# 生成文件名
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
FILENAME="screenshot-$TIMESTAMP.png"
FILEPATH="$SAVE_DIR/$FILENAME"

# 显示帮助信息
show_help() {
    echo "截图脚本 - 使用 gnome-screenshot"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -a    选区截图（默认）"
    echo "  -w    窗口截图"
    echo "  -f    全屏截图"
    echo "  -h    显示此帮助信息"
    echo ""
    echo "如果不带参数运行，将显示交互式菜单"
}

# 交互式菜单
show_menu() {
    echo "请选择截图模式："
    echo "  1) 选区截图"
    echo "  2) 窗口截图"
    echo "  3) 全屏截图"
    echo "  4) 退出"
    echo -n "请输入选项 [1-4]: "
    read -r choice

    case $choice in
        1) MODE="-a" ;;
        2) MODE="-w" ;;
        3) MODE="" ;;
        4) exit 0 ;;
        *) echo "无效选项，使用默认选区模式"; MODE="-a" ;;
    esac
}

# 解析命令行参数
MODE="-a"  # 默认为选区截图

while getopts "awfh" opt; do
    case $opt in
        a) MODE="-a" ;;
        w) MODE="-w" ;;
        f) MODE="" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done

# 如果没有参数且没有通过 getopts 设置 MODE（即没有 -a/-w/-f 参数）
if [ $# -eq 0 ]; then
    show_menu
fi

# 执行截图
echo "正在截图..."
if [ -z "$MODE" ]; then
    gnome-screenshot --file="$FILEPATH"
else
    gnome-screenshot $MODE --file="$FILEPATH"
fi

# 检查截图是否成功
if [ $? -eq 0 ] && [ -f "$FILEPATH" ]; then
    echo "截图已保存到: $FILEPATH"

    # 复制到剪贴板
    echo "正在复制到剪贴板..."
    copy_to_clipboard "$FILEPATH"
    echo "已复制到剪贴板"

    # 启动 ksnip 编辑
    echo "正在用 ksnip 打开编辑..."
    ksnip "$FILEPATH" &
else
    echo "截图失败！" >&2
    exit 1
fi
