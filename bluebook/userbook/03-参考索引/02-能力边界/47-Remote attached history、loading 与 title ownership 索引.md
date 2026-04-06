# Remote attached history、loading 与 title ownership 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md`
- `05-控制面深挖/28-remote 会话、session 命令、assistant viewer 与 remote-safe commands：为什么远端会话 client、viewer 与 bridge host 不是同一种远程工作流.md`
- `05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`

边界先说清：

- 这页不是 `viewerOnly` 总论
- 这页只抓 attached viewer 的 transcript 来源、首问 loading 与 title ownership 分叉

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Owner Initial Work` | 创建者进入时远端是否已经在跑首问 | `hasInitialPrompt` |
| `Viewer History Source` | attached viewer 是否额外去拉旧 transcript | `useAssistantHistory` |
| `Latest Anchor` | 初次补历史从哪里开始 | `anchor_to_latest` |
| `Older Cursor` | 继续往更旧处翻页靠什么 | `before_id` |
| `Title Ownership` | 当前本地是否拥有 title rewrite | `updateSessionTitle(...)` |
| `History Sentinel` | 当前是在补旧历史、失败，还是已经到 session 起点 | `loading older messages…` / `start of session` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| attached viewer 一进来 loading = 它自己发起了首问 | 这通常是 owner 线的 `hasInitialPrompt` |
| attached transcript = live stream | attached viewer 还会补历史 |
| 初始补历史 = 从头 replay | 初始页先走 `anchor_to_latest` |
| 向上滚 = 继续等 live stream | 那是在走 `before_id` 的 older page |
| 看见 title = 拥有 title rewrite | viewer 看到 title，不等于拥有主权 |
| `loading older messages…` = 远端仍在忙 | 这是历史分页 sentinel，不是运行态 signal |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | attached viewer 的 transcript 不是单一来源；首问 loading、历史翻页与 title ownership 是不同对象 |
| 条件公开 | history paging gated on `viewerOnly` 与 KAIROS；`hasInitialPrompt` 只属于 owner 创建线；title rewrite 只在非 viewerOnly 且无初始 prompt 时发生 |
| 内部/实现层 | sentinel UUID、fill-viewport budget、scroll-anchor compensation、paging loop 预算 |

## 4. 七个检查问题

- 当前说的是 owner 首问，还是 attached viewer 补看？
- transcript 现在来自 live stream，还是 history API？
- 这是 newest page，还是 older page？
- 现在的 UI signal 是远端在忙，还是历史在补？
- 本地拥有 title rewrite，还是只在消费 title？
- 我是不是又把 `viewerOnly` 总论写回来了？
- 我是不是又把 attached transcript 写成单一来源了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
