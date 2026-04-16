# 个人知识库（剧本写作）使用说明

本目录为 **Obsidian Vault 根目录**，路径：`/Users/aemon/Documents/AI/work/个人知识库/`。

设计理念：原始材料入库 → 用 LLM 将 raw Markdown **编译**为结构化笔记与概念网 → 周期性 **lint** 维护（与 Karpathy 式「Markdown 优先知识库」一致）。

---

## 1. 首次使用

1. 安装 [Obsidian](https://obsidian.md/)，选择 **打开本地库**，指向本文件夹。
2. 建议安装社区插件（按需）：**Dataview**、**Templater**、**Periodic Notes**。
3. 从 [[首页]] 或 [[_meta/moc/MOC-总览|主题索引]] 开始浏览。

---

## 2. 目录结构

| 路径 | 用途 |
|------|------|
| `00-inbox/` | 刚转换的 md、未分类片段；OpenClaw 等外部写入的剪藏也可放此处 |
| `01-raw/` | 可选：保留原始 epub/pdf；`incoming/` 用于自动监视入库的 PDF |
| `02-library/` | 编译后的书籍/资料主笔记 |
| `03-concepts/` | 独立概念词条 |
| `04-writing/` | 你自己的大纲、人物卡、项目笔记 |
| `_meta/` | 模板、MOC、脚本、维护清单、导入错误日志 |

### 特鲁比核心书单（已建 `02-library` 主笔记）

| 书 | 笔记文件 |
|----|----------|
| 《故事写作大师班》 | `02-library/故事写作大师班.md`（通用结构） |
| 《类型故事写作大师班》 | `02-library/类型故事写作大师班.md`（十四种类型与节拍） |

导航入口：**[[首页]]** → **[[_meta/moc/MOC-总览|MOC 总览]]**；类型专题：**[[_meta/moc/MOC-类型与观众契约|MOC-类型与观众契约]]**。

---

## 3. 格式转换

### 3.1 EPUB → Markdown（pandoc）

1. 安装 [pandoc](https://pandoc.org/)（macOS 可用 `brew install pandoc`）。
2. 在终端执行（路径按实际调整）：

```bash
"/Users/aemon/Documents/AI/work/个人知识库/_meta/tools/convert_epub.sh" "/path/to/book.epub"
```

输出：`00-inbox/<书名安全化>.md`，图片在 `00-inbox/_media/<书名>/`。

### 3.2 PDF → Markdown（MinerU）

1. 按 [MinerU 官方文档](https://opendatalab.github.io/MinerU/usage/quick_usage/) 在**本机**安装，确保终端能执行 `mineru`。
2. 单次转换：

```bash
"/Users/aemon/Documents/AI/work/个人知识库/_meta/tools/convert_pdf_mineru.sh" "/path/to/file.pdf"
```

输出目录：`00-inbox/<文件名安全化>/`（具体子文件以 MinerU 版本为准）。

3. 若命令失败，查看 `_meta/ingest-errors.log`。

> **说明**：MinerU 子命令与参数可能随版本变化；若脚本报错，请以官方 `mineru --help` 为准，直接修改 `_meta/tools/convert_pdf_mineru.sh` 中的调用行。

### 3.3 自动化（可选）

- 将待处理 PDF 放入 `01-raw/incoming/`，运行：

```bash
"/Users/aemon/Documents/AI/work/个人知识库/_meta/tools/watch_incoming.sh"
```

需已安装 `fswatch`（`brew install fswatch`）。成功后 PDF 会移到 `01-raw/processed/`。

---

## 4. LLM「编译」与概念网

将 MinerU/pandoc 得到的 raw md 复制到 Cursor 或 Obsidian，配合提示词整理为 `02-library/` 与 `03-concepts/` 中的结构化笔记。

- 提示词模板：[[_meta/prompts/llm-compile|llm-compile.md]]
- 笔记模板：`_meta/templates/来源笔记模板.md`、`_meta/templates/概念卡模板.md`

要求模型在输出中保留**来源锚点**（章节/段落），避免编造原书未出现的内容。

---

## 5. 周期性维护（lint）

执行清单：[[_meta/periodic-lint-checklist|periodic-lint-checklist.md]]

Dataview 示例（需安装 Dataview）：[[_meta/dataview-示例|dataview-示例.md]]

---

## 6. 外链与剪藏（OpenClaw）

微信公众号/网页剪藏由 **OpenClaw** 单独处理；若其将 Markdown 写入 `00-inbox/`，后续仍可按第 4 节做「编译」与链接维护。

---

## 7. 快捷命令汇总

| 操作 | 命令或位置 |
|------|------------|
| EPUB 转 md | `_meta/tools/convert_epub.sh` |
| PDF 转 md | `_meta/tools/convert_pdf_mineru.sh` |
| 监视 incoming PDF | `_meta/tools/watch_incoming.sh` |
| 主题导航 | `_meta/moc/MOC-总览.md` |

---

## 8. 参考链接

- MinerU：[Quick Usage](https://opendatalab.github.io/MinerU/usage/quick_usage/) · [GitHub](https://github.com/opendatalab/MinerU)
- Pandoc：<https://pandoc.org/>
