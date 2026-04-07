# `getSessionFilesLite`、`enrichLogs`、`LogSelector`、`SessionPreview` 与 `loadFullLog` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/157-getSessionFilesLite、enrichLogs、LogSelector、SessionPreview 与 loadFullLog：为什么 resume 的列表摘要面不是 preview transcript.md`
- `05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`
- `05-控制面深挖/156-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory 与 fetchLatestEvents：为什么 resume preview 的本地 transcript 快照不是 attached viewer 的 remote history.md`

边界先说清：

- 这页不是 `/resume` 总表。
- 这页不是 local vs remote history provenance 页。
- 这页只抓 `/resume` 内部的列表摘要面与 preview transcript 面的差异。

## 1. 两层 local durable surface

| 面 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| 列表摘要面 | 可进入 resume picker 的 session 摘要 | `getSessionFilesLite()`、`enrichLogs()`、`LogSelector` |
| preview transcript 面 | 某条 session 的完整正文预览 | `SessionPreview`、`loadFullLog()`、`Messages` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 列表和 preview 只是同一 transcript 的薄厚两层 | 列表先走 lite/enrich，preview 才 full hydrate |
| `enrichLogs()` 已经把 transcript 读全 | 它只补摘要字段与过滤 |
| 列表看到的 summary 就是 preview 正文的缩略图 | 两者是不同 consumer contract |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | lite -> enrich -> list； full hydrate -> preview |
| 条件公开 | 只有进入 preview 时才触发 `loadFullLog()` |
| 内部/灰度层 | 列表 enrichment 字段与 snippet/search 细节仍可能继续调整 |

## 4. 五个检查问题

- 我现在写的是列表摘要面，还是 preview transcript 面？
- 我是不是把 `enrichLogs()` 误写成 full transcript hydrate？
- 我是不是忽略了列表行根本不直接消费 `messages`？
- 我是不是把 152/156 的结论搬回来重写了？
- 我是不是把共享 durable source 误写成共享 consumer contract？

## 5. 源码锚点

- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/components/LogSelector.tsx`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/commands/resume/resume.tsx`
