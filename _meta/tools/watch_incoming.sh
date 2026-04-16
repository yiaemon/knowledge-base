#!/usr/bin/env bash
# 监视 01-raw/incoming/，出现新 PDF 时调用 convert_pdf_mineru.sh
# 依赖：brew install fswatch
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
INCOMING="$VAULT_ROOT/01-raw/incoming"
PROCESSED="$VAULT_ROOT/01-raw/processed"
CONV="$SCRIPT_DIR/convert_pdf_mineru.sh"

mkdir -p "$INCOMING" "$PROCESSED"

if ! command -v fswatch >/dev/null 2>&1; then
  echo "请先安装 fswatch: brew install fswatch"
  exit 1
fi

echo "监视目录: $INCOMING"
fswatch -o "$INCOMING" | while read -r; do
  for f in "$INCOMING"/*.pdf; do
    [[ -e "$f" ]] || continue
    echo "处理: $f"
    "$CONV" "$f" && mv "$f" "$PROCESSED/" || echo "失败保留在 incoming: $f"
  done
done
