# 安全状态机宪法速查表：state family、forbidden shortcut、blocking mechanism与distortion prevented

## 1. 这一页服务于什么

这一页服务于 [132-安全状态机宪法：为什么Claude Code不仅定义状态，还封死非法跃迁、旧写者回魂与假恢复](../132-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9C%BA%E5%AE%AA%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E4%BB%85%E5%AE%9A%E4%B9%89%E7%8A%B6%E6%80%81%EF%BC%8C%E8%BF%98%E5%B0%81%E6%AD%BB%E9%9D%9E%E6%B3%95%E8%B7%83%E8%BF%81%E3%80%81%E6%97%A7%E5%86%99%E8%80%85%E5%9B%9E%E9%AD%82%E4%B8%8E%E5%81%87%E6%81%A2%E5%A4%8D.md)。

如果 `132` 的长文解释的是：

`为什么 Claude Code 的高级性不只在“有状态机”，更在“有非法跃迁禁令”，`

那么这一页只做一件事：

`把主要 state family 的 forbidden shortcut、blocking mechanism 与阻止的失真压成一张矩阵。`

## 2. 宪法矩阵

| state family | forbidden shortcut | blocking mechanism | distortion prevented | 关键证据 |
| --- | --- | --- | --- | --- |
| permission mode family | `plan -> plan` 被误判为 leave；gate 未开却直跳 `auto` | same-mode no-op；gate disabled 直接 throw | 伪跃迁、副作用误触发、高风险态越权进入 | `permissionSetup.ts:602-603,627-630` |
| auto gate async transition family | 用 async await 前的旧 context 回写当前 context | 返回 `updateContext(ctx)` transform，而非预计算快照；fresh config re-check | stale snapshot 覆盖用户中途 mode change | `permissionSetup.ts:1035-1041,1078-1090,1182-1189` |
| step-up authorization family | `insufficient_scope` 走 refresh，伪装成已升级授权 | `needsStepUp` 时省略 `refresh_token`，强制走 PKCE step-up | 低强度证明伪装成高强度证明 | `mcp/auth.ts:1625-1650` |
| MCP auth-failure family | cached `needs-auth` 后继续盲连 / 重试风暴 | skip connect；直接回 `needs-auth` + auth tool | 假恢复、连接风暴、错误 repair path | `mcp/client.ts:2308-2321` |
| stale MCP client family | 旧 timer / 旧 `onclose` / 旧 config closure 回写新状态 | clear timeout；删 `onclose`；仅清 connected stale clients | 旧写者回魂、fresh connection 被旧世界覆盖 | `useManageMCPConnections.ts:791-810` |
| MCP enable/disable family | disable 时先断开，后写权威状态，导致 onclose 又重连 | persist disabled state to disk first，再 clear cache / update state | “我刚禁用却又被自动拉起”的反宪法跃迁 | `useManageMCPConnections.ts:1085-1117` |
| bridge resume family | fatal exit 后继续打印 resume hint | fatal exits 下跳过 resume promise；避免矛盾提示 | 对用户发布无法兑现的恢复承诺 | `bridgeMain.ts:1515-1522` |
| bridge pointer family | multi-session 场景也写 resume pointer | 仅 `single-session` 下写 pointer，并持续刷新 | 矛盾配置、orphaned pointer、错误可恢复承诺 | `bridgeMain.ts:2700-2728` |

## 3. 最短判断公式

判断某段安全逻辑是否已经上升到“状态机宪法”，先问四句：

1. 它封死了哪条看似方便的 shortcut
2. 它靠什么 blocking mechanism 真正阻断
3. 它预防的是哪种失真，而不只是普通失败
4. 若拿掉这条禁令，系统会不会开始说谎或被旧上下文改写

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “有状态枚举就够了” | 忽略非法跃迁才是真风险 |
| “cleanup 只是工程卫生” | 忽略它其实在撤销旧写者的写权 |
| “refresh / reconnect / resume 都是恢复” | 忽略不同 repair path 的安全强度差异 |
| “给用户一个乐观提示总比没有好” | 忽略错误承诺本身也是安全失真 |

## 5. 一条硬结论

Claude Code 的安全控制面之所以比普通运行时更成熟，不是因为：

`状态更多，`

而是因为：

`它越来越明确地回答了哪些状态根本不配通过某些捷径到达。`

