---
title: Dataview 示例（需安装 Dataview 插件）
type: meta
---

# Dataview 示例

安装社区插件 **Dataview** 后，下列代码块会列出未整理来源（`status: ingested` 且仍停在 inbox 的可自行改条件）。

```dataview
TABLE title, type, status, topic
FROM "00-inbox" OR "02-library"
WHERE type = "source"
SORT file.mtime DESC
LIMIT 20
```

可按需修改 `FROM` 与 `WHERE`。
