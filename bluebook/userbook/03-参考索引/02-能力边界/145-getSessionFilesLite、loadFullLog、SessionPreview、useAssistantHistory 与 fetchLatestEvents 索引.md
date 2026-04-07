# `getSessionFilesLite`、`loadFullLog`、`SessionPreview`、`useAssistantHistory` 与 `fetchLatestEvents` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/156-getSessionFilesLite、loadFullLog、SessionPreview、useAssistantHistory 与 fetchLatestEvents：为什么 resume preview 的本地 transcript 快照不是 attached viewer 的 remote history.md`
- `05-控制面深挖/58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md`
- `05-控制面深挖/153-SENTINEL_LOADING、SENTINEL_LOADING_FAILED、SENTINEL_START、maybeLoadOlder、fillBudgetRef、remoteConnectionStatus 与 BriefIdleStatus：为什么 attached viewer 的历史翻页哨兵不是 remote presence surface.md`

边界先说清：

- 这页不是 attached viewer history 总表。
- 这页不是 replay dedup 页，也不是 ownership 页。
- 这页只抓 `/resume` local preview 与 attached viewer remote history 这两张历史来源面。

## 1. 两张 history surface

| 面 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| local preview 面 | 本地 durable log 的只读快照重建 | `getSessionFilesLite()`、`loadFullLog()`、`SessionPreview` |
| attached remote history 面 | 远端 session events API 的增量补页 | `useAssistantHistory()`、`fetchLatestEvents()`、`fetchOlderEvents()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| attached viewer 是 `/resume` preview 的联网版 | 两边的 authoritative history source 完全不同 |
| 两边都进 `Messages`，所以只是同一壳 | 共享 renderer 不等于共享历史账 |
| preview 读的是当前 session 的 live state | 它读的是 durable JSONL transcript |
| attached viewer 只是把本地 transcript 换成远端地址 | 它实际上走的是 `/v1/sessions/{id}/events` 分页 API |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `/resume` preview = local durable log；attached viewer history = remote events API |
| 条件公开 | preview 先走 lite log，只有进入 preview 时才 full hydrate；attached viewer 只有 scroll-up 时才取 older page |
| 内部/灰度层 | attached viewer 未来是否补离线 fallback、preview 是否继续加 lightweight enrichment 仍可能调整 |

## 4. 五个检查问题

- 我现在写的是 local preview，还是 remote history pager？
- 我是不是把共享 `Messages` renderer 误写成共享 history source？
- 我是不是忽略了 preview 的 lite->full hydration 模型？
- 我是不是忽略了 attached viewer 的 `/v1/sessions/{id}/events` API 来源？
- 我是不是又把 58/118/153 的结论压回来？

## 5. 源码锚点

- `claude-code-source-code/src/commands/resume/resume.tsx`
- `claude-code-source-code/src/components/LogSelector.tsx`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
