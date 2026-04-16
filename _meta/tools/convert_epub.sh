#!/usr/bin/env bash
# EPUB → Markdown（pandoc）。依赖：brew install pandoc（或官网安装）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
INBOX="$VAULT_ROOT/00-inbox"
MEDIA="$INBOX/_media"

usage() {
  echo "用法: $0 <文件.epub> [输出基名]"
  echo "  输出: $INBOX/<基名>.md，图片在 $MEDIA/<基名>/"
  exit 1
}

[[ $# -ge 1 ]] || usage
[[ -f "$1" ]] || { echo "文件不存在: $1" >&2; exit 1; }
command -v pandoc >/dev/null 2>&1 || { echo "请先安装 pandoc: https://pandoc.org" >&2; exit 1; }

EPUB="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
BASENAME="${2:-$(basename "$EPUB" .epub)}"
SAFE="${BASENAME//[^a-zA-Z0-9._-]/_}"
OUT_DIR="$INBOX"
MEDIA_DIR="$MEDIA/$SAFE"
mkdir -p "$MEDIA_DIR"

OUT_MD="$OUT_DIR/${SAFE}.md"
pandoc "$EPUB" -o "$OUT_MD" --extract-media="$MEDIA_DIR"
echo "已生成: $OUT_MD"
echo "媒体目录: $MEDIA_DIR"
