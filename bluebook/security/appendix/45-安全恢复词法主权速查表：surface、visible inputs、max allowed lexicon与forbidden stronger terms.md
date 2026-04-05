# 安全恢复词法主权速查表：surface、visible inputs、max allowed lexicon与forbidden stronger terms

## 1. 这一页服务于什么

这一页服务于 [61-安全恢复词法主权：为什么通知、摘要、footer与账本不能各自发明恢复语言，必须服从同一套命名仲裁](../61-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E9%80%9A%E7%9F%A5%E3%80%81%E6%91%98%E8%A6%81%E3%80%81footer%E4%B8%8E%E8%B4%A6%E6%9C%AC%E4%B8%8D%E8%83%BD%E5%90%84%E8%87%AA%E5%8F%91%E6%98%8E%E6%81%A2%E5%A4%8D%E8%AF%AD%E8%A8%80%EF%BC%8C%E5%BF%85%E9%A1%BB%E6%9C%8D%E4%BB%8E%E5%90%8C%E4%B8%80%E5%A5%97%E5%91%BD%E5%90%8D%E4%BB%B2%E8%A3%81.md)。

如果 `61` 的长文解释的是：

`为什么不同 surface 不能各自发明恢复语言，`

那么这一页只做一件事：

`把 surface、visible inputs、max allowed lexicon 与 forbidden stronger terms 压成一张命名仲裁矩阵。`

## 2. 词法主权矩阵

| surface | visible inputs | max allowed lexicon | forbidden stronger terms | 为什么不能说更满 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| IDE 基础 hook | 单个 IDE MCP client 的 `connected / pending / disconnected / null` | `connected`、`pending`、`disconnected`、`unknown` | `resolved`、`working normally`、`fully recovered` | 这里只看到了连接态，没有看到安装失败、上下文选择和解释闭环 | `useIdeConnectionStatus.ts:4-32` |
| IDE 通知层 | `ideStatus`、安装错误、JetBrains 特例、hint 条件 | `disconnected`、`plugin not connected`、`install failed`、`hint available` | `resolved`、`healthy`、`all clear` | 通知层只负责提示和跳转，不是账本 writer 或 explanation signer | `useIDEStatusIndicator.tsx:43-165` |
| `/status` IDE 摘要 | IDE 安装态与 ide client 连接态 | `Connected to ...`、`Installed ...`、`Not connected` | `resolved`、`fully active`、`ready for all workflows` | 摘要层是在做盘点压缩，不是在给恢复链签最终结论 | `status.tsx:38-88` |
| bridge status label / footer | `error / reconnecting / connected / sessionActive`，且 failed 被分流出 footer | `failed`、`reconnecting`、`active`、`connecting` | `resolved`、`read-ready`、`fully attached`、`explanation-closed` | 当前实现已把 `sessionActive || connected` 压成 `active`，更强词会把 readiness 差异说没 | `bridgeStatusUtil.ts:113-150`、`PromptInputFooter.tsx:173-189` |
| MCP 通知层 | `failed / needs-auth` 与 claude.ai / local 区分 | `failed`、`needs auth`、`unavailable` | `resolved`、`fully healthy`、`safe to ignore` | 通知层是动作导向提醒，没看到完整 retry/repair/readback 闭环 | `useMcpConnectivityStatus.tsx:25-74` |
| `/status` MCP 摘要 | MCP clients 的聚合计数 | `n connected`、`n pending`、`n need auth`、`n failed` | `all healthy`、`fully recovered`、`resolved` | 聚合计数天然丢失单实例细节，只配盘点，不配高强解释 | `status.tsx:89-114` |
| authoritative writer / higher signer | `pending_action`、`task_summary`、`worker_status`、delivery、explanation closure | 可以定义 `cleared`，并为 `resolved` 提供依据 | 不受上面这些 lower surfaces ceiling 的约束 | 它才最接近正式账本与解释闭环 | `sessionState.ts:92-130`、`ccrClient.ts:476-520`、`49`-`61` 主线归纳 |

## 3. 最短判断公式

审查一个界面词汇是否越级时，先问四句：

1. 这个 surface 当前到底看到了哪些 inputs
2. 它当前最多配说到 hidden、suppressed、cleared 还是 resolved
3. 它是不是把局部 ready / aggregate summary 说成了高层闭环
4. 如果更高层账本缺失，这个词还能成立吗

## 4. 最常见的四类命名越级错误

| 命名越级错误 | 会造成什么问题 |
| --- | --- |
| 把 `Installed` 说成 `Connected` | 安装事实冒充在线事实 |
| 把 `connected` / `active` 说成 `resolved` | 局部 ready 冒充全链恢复 |
| 把通知层的 `failed` / `needs auth` 说成终局结论 | 动作提醒冒充最终解释 |
| 把聚合计数说成 `all healthy` | summary layer 越级替 individual traces 签字 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是不同界面用不同句式，  
而是：

`不同界面基于不同输入，却被允许说同样满的恢复语言。`
