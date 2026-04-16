#!/usr/bin/env bash
# PDF → Markdown（MinerU CLI）。请先按官方文档安装 MinerU：https://opendatalab.github.io/MinerU/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUT_BASE="$VAULT_ROOT/00-inbox"
LOG="$VAULT_ROOT/_meta/ingest-errors.log"

usage() {
  echo "用法: $0 <文件.pdf>"
  echo "  将 PDF 转为 md，输出在: $OUT_BASE/<同名子目录>/"
  echo "  若本机未安装 MinerU，请查看 README「MinerU 安装」一节。"
  exit 1
}

[[ $# -ge 1 ]] || usage
[[ -f "$1" ]] || { echo "文件不存在: $1" >&2; exit 1; }

PDF="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
BASENAME="$(basename "$PDF" .pdf)"
SAFE="${BASENAME//[^a-zA-Z0-9._-]/_}"
OUT_DIR="$OUT_BASE/$SAFE"
mkdir -p "$OUT_DIR"

ts() { date '+%Y-%m-%d %H:%M:%S'; }

if command -v mineru >/dev/null 2>&1; then
  mineru -p "$PDF" -o "$OUT_DIR" 2>&1 | tee -a "$LOG" || {
    echo "$(ts) mineru 失败: $PDF" >> "$LOG"
    exit 1
  }
  echo "完成，输出目录: $OUT_DIR"
else
  echo "未找到 mineru 命令。请安装 MinerU 后将 mineru 加入 PATH。" | tee -a "$LOG"
  exit 1
fi
