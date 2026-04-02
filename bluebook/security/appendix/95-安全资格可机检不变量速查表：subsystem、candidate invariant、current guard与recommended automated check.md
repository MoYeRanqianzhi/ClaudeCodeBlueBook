# 安全资格可机检不变量速查表：subsystem、candidate invariant、current guard与recommended automated check

## 1. 这一页服务于什么

这一页服务于 [111-安全资格可机检不变量：为什么transition constitution若不能被schema、assertion与property-test自动验证，就仍然太依赖维护者记忆](../111-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%8F%AF%E6%9C%BA%E6%A3%80%E4%B8%8D%E5%8F%98%E9%87%8F%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88transition%20constitution%E8%8B%A5%E4%B8%8D%E8%83%BD%E8%A2%ABschema%E3%80%81assertion%E4%B8%8Eproperty-test%E8%87%AA%E5%8A%A8%E9%AA%8C%E8%AF%81%EF%BC%8C%E5%B0%B1%E4%BB%8D%E7%84%B6%E5%A4%AA%E4%BE%9D%E8%B5%96%E7%BB%B4%E6%8A%A4%E8%80%85%E8%AE%B0%E5%BF%86.md)。

如果 `111` 的长文解释的是：

`宪法若不能被机器持续验证，就仍然不够稳，`

那么这一页只做一件事：

`把各 subsystem 最值得提炼的 candidate invariant、当前已有 guard，以及推荐的自动化验证方式压成一张矩阵。`

## 2. 可机检不变量矩阵

| subsystem | candidate invariant | current guard | recommended automated check | 关键证据 |
| --- | --- | --- | --- | --- |
| notifications | stale timeout cannot clear new current | current-key compare before `current=null` | property test: old timer + new current reorderings | `notifications.tsx:54-68,90-104,131-146` |
| notifications | same family cardinality must stay 1 | duplicate prevention via `shouldAdd` | property test: repeated same-key add never yields duplicates | `notifications.tsx:172-188` |
| notifications | absent object cannot be retired | `if (!isCurrent && !inQueue) return prev` | table test: remove on absent key is no-op | `notifications.tsx:193-212` |
| bridge | fuse-blown session cannot remain retry-enabled | repeated-failure guard disables bridge | transition-table test for failure count threshold | `useReplBridge.tsx:113-127` |
| bridge | cleared error cannot still trigger disable timer | timeout checks `replBridgeError` still present | property test over timer + clear interleavings | `useReplBridge.tsx:354-360,636-642` |
| bridge | strong connected state requires evidence bundle | connected/ready writes guarded by handle/url/id checks | transition-table test: missing bundle never yields connected | `useReplBridge.tsx:230-245,252-258,525-535,592-605` |
| permissions | guards must precede centralized transition | explicit pre-guard before `transitionPermissionMode` and invariant-violation comment | integration test for guard-before-transition ordering | `useReplBridge.tsx:417-453`; `permissionSetup.ts:597-645` |
| plugin | `needsRefresh` cannot clear without full refresh completion | `Do NOT reset`; `refreshActivePlugins()` consumes it | table test: only refresh completion path clears pending | `useManagePlugins.ts:293-303`; `refresh.ts:59-67,123-138` |
| pointer | only schema-valid + fresh pointer may enter resumable current | `safeParse` + TTL stale clear | schema test + boundary test around TTL | `bridgePointer.ts:83-109` |
| pointer | transient failure must not equal fatal retirement | clear pointer only on fatal reconnect failure | table-driven branch test: transient vs fatal produce different retire policy | `bridgeMain.ts:2524-2534` |
| state store | identical next/prev must be semantic no-op | `Object.is(next, prev)` short-circuit | low-level store invariant test | `store.ts:20-27` |

## 3. 最短判断公式

看到某条 guard 时，先问五句：

1. 它背后对应的是哪条 candidate invariant
2. 这条 invariant 现在只在运行时守卫，还是已经有自动化验证
3. 它最适合做 schema check、runtime assertion 还是 property test
4. 如果这条 invariant 失效，最坏后果是什么
5. 它是否已经值得进入统一 invariant catalog

## 4. 最常见的五类未机检风险

| 风险方式 | 会造成什么问题 |
| --- | --- |
| guard 只在代码里，没有自动化验证 | 重构后静默失效 |
| 只做 schema check，不做时序测试 | stale actor / timer interleaving 漏洞仍可能存在 |
| 只做单元 happy-path，不做 forbidden transition 表 | 宪法条文无法系统证明 |
| 只测最终结果，不测 guard 顺序 | guard-before-transition 退化难察觉 |
| 没有 invariant catalog | 相似 guard 无法统一升级 |

## 5. 一条硬结论

对安全控制面来说，  
真正稳固的不是：

`代码里出现了很多 guard，`

而是：

`这些 guard 已经被提升成机器可持续验证的不变量。`
