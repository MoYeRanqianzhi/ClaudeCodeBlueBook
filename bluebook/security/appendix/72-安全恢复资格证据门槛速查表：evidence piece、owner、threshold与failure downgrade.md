# 安全恢复资格证据门槛速查表：evidence piece、owner、threshold与failure downgrade

## 1. 这一页服务于什么

这一页服务于 [88-安全恢复资格证据门槛：为什么即使signer正确，仍可恢复也必须建立在最小truth-bundle之上](../88-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E8%AF%81%E6%8D%AE%E9%97%A8%E6%A7%9B%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E5%8D%B3%E4%BD%BFsigner%E6%AD%A3%E7%A1%AE%EF%BC%8C%E4%BB%8D%E5%8F%AF%E6%81%A2%E5%A4%8D%E4%B9%9F%E5%BF%85%E9%A1%BB%E5%BB%BA%E7%AB%8B%E5%9C%A8%E6%9C%80%E5%B0%8Ftruth-bundle%E4%B9%8B%E4%B8%8A.md)。

如果 `88` 的长文解释的是：

`为什么恢复资格必须依赖最小 truth bundle，`

那么这一页只做一件事：

`把不同 evidence piece 到底由谁提供、最低门槛是什么、失败后该降级成什么压成一张证据门槛矩阵。`

## 2. 恢复资格证据门槛矩阵

| evidence piece | owner | threshold | if missing / failed | resulting downgrade | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| valid pointer candidate | pointer reader / worktree resolver | 至少找到一个 non-stale pointer candidate | 无 pointer | 直接退出到 “start a new one” | `bridgeMain.ts:2149-2160`、`bridgePointer.ts:76-113,115-184` |
| valid session id | bridgeMain resume verifier | `validateBridgeId(...)` 通过 | id 非法 | 直接拒绝 resume flow | `bridgeMain.ts:2363-2373` |
| fresh auth context | OAuth freshness gate | refresh token cache，避免 expired-but-present token 污染判断 | token 失真 | 不可信 existence check，不能继续签发资格 | `bridgeMain.ts:2374-2378` |
| session existence | bridge session fetch | `getBridgeSession(...)` 返回对象 | session 不存在 | clear pointer + 不可恢复 | `bridgeMain.ts:2380-2398` |
| environment binding | bridge session fetch | `session.environment_id` 存在 | 无 `environment_id` | clear pointer + 不可恢复 | `bridgeMain.ts:2400-2410` |
| environment continuity | bridgeMain resume verifier | backend env 与请求恢复 env 匹配 | env mismatch / expired / reaped | 降级到 fresh session fallback | `bridgeMain.ts:2473-2489` |
| reconnectability | bridge reconnect verifier | 至少一个 candidateId 可 `reconnectSession(...)` 成功 | reconnect 全部失败 | 按 transient/fatal 决定 retryable 或不可恢复 | `bridgeMain.ts:2498-2540` |
| failure semantics | failure semantics owner | 明确区分 transient 与 fatal | 语义不明或被压平 | retry hint 与撤回时机都失真 | `bridgeMain.ts:2524-2540` |
| mode compatibility | mode selector / pointer publisher | `single-session` 且 resume 语义一致 | mode 冲突 | 不发布 pointer / 清理旧 pointer | `bridgeMain.ts:2290-2326,2709-2728` |

## 3. 最短判断公式

看到一句“仍可恢复”时，先问五句：

1. 它背后的 evidence piece 有哪些
2. 这些 evidence 分别由谁提供
3. 每一项是否已经达到最低 threshold
4. 缺哪一项时系统应降级到 candidate、retryable、fresh-session-required 还是 retired
5. 当前是在依据 proof bundle 发声，还是在依据 hope bundle 发声

## 4. 最常见的五类证据门槛失守

| 失守方式 | 会造成什么问题 |
| --- | --- |
| 把 pointer 当最终证据 | carrier 被误当真相 |
| 不刷新 auth 就查 session | 身份问题伪装成对象不存在 |
| 不检查 `environment_id` | 存在对象被误说成可恢复对象 |
| 不区分 env mismatch 与 reconnect failure | fresh fallback 与真正 resume 被混淆 |
| 不区分 transient / fatal | retryable 边界与 dead boundary 被压扁 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`看见一个旧对象就觉得还能恢复，`

而是：

`只有当最小 truth bundle 成立时，系统才把“仍可恢复”从希望升级成资格。`
