# 安全资格字段优先级与抢占规则速查表：signal、priority、preemption target与display policy

## 1. 这一页服务于什么

这一页服务于 [105-安全资格字段优先级与抢占规则：为什么不是所有字段都该平权显示，而应让强断点抢占弱信号](../105-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%AD%97%E6%AE%B5%E4%BC%98%E5%85%88%E7%BA%A7%E4%B8%8E%E6%8A%A2%E5%8D%A0%E8%A7%84%E5%88%99%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E6%89%80%E6%9C%89%E5%AD%97%E6%AE%B5%E9%83%BD%E8%AF%A5%E5%B9%B3%E6%9D%83%E6%98%BE%E7%A4%BA%EF%BC%8C%E8%80%8C%E5%BA%94%E8%AE%A9%E5%BC%BA%E6%96%AD%E7%82%B9%E6%8A%A2%E5%8D%A0%E5%BC%B1%E4%BF%A1%E5%8F%B7.md)。

如果 `105` 的长文解释的是：

`为什么字段展示必须服从优先级与抢占规则，`

那么这一页只做一件事：

`把不同 signal 的 priority、抢占目标与展示策略压成一张优先级矩阵。`

## 2. 安全资格字段优先级矩阵

| signal | priority | preemption target | display policy | 关键证据 |
| --- | --- | --- | --- | --- |
| bridge failed | `immediate` | 弱状态通知、footer 平静态 | 立即抢占通知通道，不留在 footer | `useReplBridge.tsx:102-112,339-349` |
| MCP failed / needs-auth | `medium` | low 信息性通知 | 中优先级问题提示，引导 `/mcp` | `useMcpConnectivityStatus.tsx:36-63` |
| plugin updated / apply needed | `low` | 不抢占更强安全断点 | 低优先级维护提示 | `usePluginAutoupdateNotification.tsx:60-64` |
| reconnecting (implicit footer) | narrow-surface winner | active / idle footer pill | 在 implicit remote 下只保留 reconnecting | `PromptInputFooter.tsx:173-185` |
| cooldown started / expired | `immediate` + `invalidates` | 对应旧 cooldown 叙事 | 新状态到来时显式驱逐旧状态 | `notifications.tsx:78-118,230-239`; `useFastModeNotification.tsx:106-121` |

## 3. 最短判断公式

看到两个字段竞争同一展示位时，先问五句：

1. 哪个 signal 风险更高
2. 哪个 signal 更需要立即动作
3. 旧 signal 是否该被 `invalidates`
4. 当前 surface 是否太窄，不适合并排展示
5. 谁更配先占用用户注意力

## 4. 最常见的五类优先级错误

| 错误方式 | 会造成什么问题 |
| --- | --- |
| 让 low 提示与 immediate 断点平权 | 高风险问题被弱化 |
| 不驱逐旧叙事 | 强弱信号并排制造混乱 |
| footer 同时塞入多个 bridge 状态 | 窄 surface 退化成噪音面 |
| medium 问题抢占过度 | 局部问题淹没更强全局断点 |
| 不给弱信号让位规则 | 旧信号 linger 破坏当前解释 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`把信号都显示出来，`

而是：

`让更强的断点拥有更强的发言权，并在必要时把更弱的信号直接挤出当前解释通道。`
