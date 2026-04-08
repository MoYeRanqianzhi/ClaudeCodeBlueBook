# Headless print remote recovery double-trunk map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/213-owner-side recovery、transport stop rule 与 compaction boundary：为什么 122、123、124、125、126、127 不是线性六连，而是双主干加两个 zoom.md`
- `05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`
- `05-控制面深挖/123-viewerOnly、history、timeout、Ctrl+C 与 title：为什么 assistant client 不是 session owner.md`
- `05-控制面深挖/124-warning、连接态、force reconnect 与 viewerOnly：为什么 recovery signer 不是同一种恢复证明.md`
- `05-控制面深挖/125-handleClose、scheduleReconnect、reconnect()、onReconnecting 与 onClose：为什么 transport recovery action-state contract 不是同一种状态.md`
- `05-控制面深挖/126-PERMANENT_CLOSE_CODES、4001 与 reconnect budget：为什么 terminality policy 不是同一种 stop rule.md`
- `05-控制面深挖/127-compacting、boundary、timeout、4001 与 keep-alive：为什么 compaction recovery contract 不是同一种恢复信号.md`

边界先说清：

- 这页不是 122-127 的细节证明总集。
- 这页不替代 213 的结构长文。
- 这页只抓“122/123 是双根，124 是 signer zoom，125 是降层根页，126/127 分到 terminality 与 compaction”的阅读图。
- 这页保护的是双主干与降层点，不把常量、gate 名或某条 surface 是否出现直接升级成稳定公共合同。

## 1. 双主干图总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 213 | 解释 122-127 的双主干 + 两个 zoom | 结构收束页 |
| 122 | 先分 watchdog / warning / reconnect / reconnecting / disconnected | owner-side recovery 根页 |
| 123 | 先分 `viewerOnly` 为什么不是 session owner | ownership 根页 |
| 124 | 继续分 warning / authority / action / projection / absence 这些 signer | signer zoom |
| 125 | 从 signer / proof 层降到 transport authority 层 | transport 根页 |
| 126 | 继续分 permanent rejection、`4001` stale exception 与 ordinary retry | terminality zoom |
| 127 | 继续分 progress、keep-alive、patience、transport exception 与 completion marker | compaction 支线 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 122-127 都在讲 recovery，所以顺着编号一路读就行 | 更稳的是双主干：`122/123/124` 与 `125/126/127` |
| 123 只是 122 的 viewer 附录 | 123 在问 owner 主权，不在继续列 recovery edge |
| 124 只是第三张 recovery state 页 | 124 在问谁能给 recovery 签字 |
| 125 只是 124 的 transport 附录 | 125 是从 proof/signer 层降到 transport authority 层的根页 |
| 126 之后自然接 127 | 126 在问 stop rule；127 在问 compaction 多合同，不是同一主语 |
| 看到或没看到 warning / brief / remote pill，就能直接证明 recovery 有或没有 | 先要问 surface 是 authority、prompt、action 还是 projection，以及它是否本来就没挂上 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | warning、reconnect action、reconnecting、disconnected 不是同一状态；`viewerOnly` 是 non-owning interactive client；`handleClose(...)` 是 transport authority path；terminality 至少分三桶；compaction 至少分五类信号 |
| 条件公开 | warning 是否出现、history 是否开启、brief 行是否挂载、`viewerOnly` 是否切掉 owner-side signer、`4001` 在当前栈里是否被当 stale exception、compaction 是否触发 keep-alive |
| 内部/灰度层 | timeout / retry / delay 常量、`KAIROS`、`remoteSessionUrl` 挂载条件、具体 cadence、`compact_boundary.preserved_segment` 与多数 UI 文案 |

## 4. 六个检查问题

- 我现在写的是 recovery edge、ownership，还是 signer surface？
- 我现在还停在 proof/signer 层，还是已经降到 transport authority 层？
- 这个 surface 是 authority、prompt、action，还是 projection？
- 我是不是把 absence 直接写成了 opposite？
- 我是不是把 `4001` 在当前 remote-session 栈里的处理，误写成了所有 transport 的稳定合同？
- 我有没有把双主干又写回成一条 recovery 线性链？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/services/compact/compact.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
