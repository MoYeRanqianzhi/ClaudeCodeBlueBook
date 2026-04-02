# 安全能力声明仲裁速查表：surface、authority kind、conflict winner-loser与forced handoff

## 1. 这一页服务于什么

这一页服务于 [75-安全能力声明仲裁：当status、notification、footer与hook同时说话时，谁有资格代表当前能力真相](../75-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%A3%B0%E6%98%8E%E4%BB%B2%E8%A3%81%EF%BC%9A%E5%BD%93status%E3%80%81notification%E3%80%81footer%E4%B8%8Ehook%E5%90%8C%E6%97%B6%E8%AF%B4%E8%AF%9D%E6%97%B6%EF%BC%8C%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E4%BB%A3%E8%A1%A8%E5%BD%93%E5%89%8D%E8%83%BD%E5%8A%9B%E7%9C%9F%E7%9B%B8.md)。

如果 `75` 的长文解释的是：

`为什么多表面并存时必须把注意力优先级与真相解释权分开，`

那么这一页只做一件事：

`把不同 surface 的 authority kind、conflict winner / loser 与 forced handoff 压成一张跨面仲裁矩阵。`

## 2. 能力声明仲裁矩阵

| surface | authority kind | primary evidence | 冲突时赢什么 | 冲突时输给谁 | forced handoff | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| MCP type layer | 原始状态边界权 | `connected / failed / needs-auth / pending / disabled` 类型集 | 赢“可用词上限” | 输给更高表面的完整用户态解释 | 向上只提供受约束状态，不直接写满文案 | `mcp/types.ts:179-220` |
| IDE 基础 hook | 窄状态基元权 | `ideClient.type` + `ideName` | 赢“connected / pending / disconnected / null” 这类基础判断 | 输给 `/status`、通知层的更具体投影 | 只交出窄状态，不直接说 installed / active | `useIdeConnectionStatus.ts:4-32` |
| notification queue | 注意力仲裁权 | `current + queue`、`priority`、`invalidates` | 赢“谁先被看见” | 输给 `/status` 或 `/mcp` 的最终解释面 | 通过优先级与失效机制让当前最重要的提示抢位 | `notifications.tsx:45-76,78-117,172-191,230-239` |
| IDE / MCP 通知层 | 异常提醒权 | disconnected、install error、failed count、needs-auth count | 赢低占位弱绿色词与不够具体的旧提示 | 输给 `/status`、`/mcp` 的完整盘点 | 主动把用户导向 `/status for info` 或 `/mcp` | `useIDEStatusIndicator.tsx:78-152`、`useMcpConnectivityStatus.tsx:29-63` |
| bridge failed notification | 紧急否定显化权 | bridge init / reconnect failure detail | 赢 footer pill 的 `active / connecting / reconnecting` | 输给后续更完整的 bridge detail / status 面 | 用 `priority: immediate` 抢占当前注意力 | `useReplBridge.tsx:102-111` |
| `/status` / `/mcp` 摘要面 | 用户态聚合解释权 | IDE 安装信息、连接信息、server counts、状态盘点 | 赢 notification / footer 的长期定性权 | 输给更底层 raw ledger 的事实来源，但不输给弱提醒面 | 成为通知层指向的正式确认入口 | `status.tsx:38-114`、`useIDEStatusIndicator.tsx:119-152`、`useMcpConnectivityStatus.tsx:29-63` |
| footer pill | 连续性弱状态权 | 极少量压缩输入，如 `connected / sessionActive / reconnecting` | 只在无冲突时保留持续反馈 | 输给 notification 与更高主权解释面 | 高风险 failed 必须让位，不继续留在 pill | `bridgeStatusUtil.ts:123-140`、`PromptInputFooter.tsx:173-189` |

## 3. 最短判断公式

看到多个表面同时说能力状态时，先问四句：

1. 这是在争“谁先被看见”，还是在争“谁代表最终解释”
2. 当前是否已有更高风险的否定词需要压过弱绿色词
3. 当前哪个 surface 只掌握局部输入，哪个 surface 掌握聚合盘点
4. 当前有没有显式 handoff，把用户导向更高主权确认面

## 4. 最常见的五类仲裁错误

| 仲裁错误 | 会造成什么问题 |
| --- | --- |
| 把 notification current 当成最终真相 | 抢位逻辑冒充解释逻辑 |
| 让 footer 的 `active` 盖过失败提示 | 连续性弱词压过高风险否定词 |
| 让 hook 直接输出满文案 | 基础状态层越权替上层下结论 |
| 让 `/status` 缺席 handoff 角色 | 通知层只能打断，用户却不知道去哪确认 |
| 没有显式 invalidation / remove 旧提示 | 低主权旧词与新高风险词并存，形成表面裂脑 |

## 5. 一条硬结论

对 Claude Code 这类多表面安全控制面来说，  
最关键的不是“谁现在正在屏幕上”，  
而是：

`谁此刻只是在抢注意力，谁才真正配代表当前能力真相。`
