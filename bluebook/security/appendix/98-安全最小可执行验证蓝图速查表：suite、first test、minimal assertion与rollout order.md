# 安全最小可执行验证蓝图速查表：suite、first test、minimal assertion与rollout order

## 1. 这一页服务于什么

这一页服务于 [114-安全最小可执行验证蓝图：为什么下一步不是泛泛补测试，而是先建一套能持续守住最贵失真的首批验证套件](../114-%E5%AE%89%E5%85%A8%E6%9C%80%E5%B0%8F%E5%8F%AF%E6%89%A7%E8%A1%8C%E9%AA%8C%E8%AF%81%E8%93%9D%E5%9B%BE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8B%E4%B8%80%E6%AD%A5%E4%B8%8D%E6%98%AF%E6%B3%9B%E6%B3%9B%E8%A1%A5%E6%B5%8B%E8%AF%95%EF%BC%8C%E8%80%8C%E6%98%AF%E5%85%88%E5%BB%BA%E4%B8%80%E5%A5%97%E8%83%BD%E6%8C%81%E7%BB%AD%E5%AE%88%E4%BD%8F%E6%9C%80%E8%B4%B5%E5%A4%B1%E7%9C%9F%E7%9A%84%E9%A6%96%E6%89%B9%E9%AA%8C%E8%AF%81%E5%A5%97%E4%BB%B6.md)。

如果 `114` 的长文解释的是：

`第一阶段该如何把最贵失真变成首批可执行测试套件，`

那么这一页只做一件事：

`把首批 suite、最先该落的 first test、最小断言与 rollout order 压成一张执行矩阵。`

## 2. 最小可执行验证蓝图矩阵

| suite | first test | minimal assertion | rollout order | 关键证据 |
| --- | --- | --- | --- | --- |
| Permission Mode Ordering Suite | guard-before-transition ordering | guard 不通过时不得推进 centralized transition | 1 | `useReplBridge.tsx:417-453`; `permissionSetup.ts:597-645` |
| Metadata Sync Suite | mode changed -> external metadata synced | 任一合法 mode 变化都会通知外部 truth surfaces | 2 | `onChangeAppState.ts:50-64` |
| Notification Truth-Integrity Suite | old timer cannot clear new current | stale actor 不得改写 current | 3 | `notifications.tsx:54-68` |
| Notification Family Suite | same key repeated add never duplicates | family cardinality 永远为 1 | 4 | `notifications.tsx:172-188` |
| Bridge Failure Lifecycle Suite | cleared error timer no-op | error 已清后旧 timer 不得 disable bridge | 5 | `useReplBridge.tsx:616-644` |
| Bridge Fuse Suite | repeated failures hit threshold and disable | failure count 达阈值后必须熔断 | 6 | `useReplBridge.tsx:31-40,113-127` |
| Plugin Refresh Completion Suite | only refresh path clears `needsRefresh` | completion 不能绕过 gate | 7 | `useManagePlugins.ts:289-302`; `refresh.ts:59-67,123-138` |
| Plugin Stale-Cache Regression Suite | old stale-cache bug stays fixed | no-op race / stale memoized result 不复发 | 8 | `refresh.ts:81-88,140-145` |
| Pointer Schema/Freshness Suite | invalid/stale pointer -> null | 只有 schema-valid + fresh pointer 才 current | 9 | `bridgePointer.ts:83-109` |
| Pointer Branch Matrix Suite | transient != fatal policy split | transient 不 clear, fatal 才 clear | 10 | `bridgeMain.ts:1525-1537,2384-2403,2524-2534` |

## 3. 最短判断公式

决定 first test 时，先问五句：

1. 这条测试能不能直接守住一类最贵失真
2. 这条测试能不能覆盖一个已有历史前科
3. 这条测试是不是最小但足够代表整类风险
4. 这条测试是否依赖先建测试骨架
5. 它是否能成为后续整套 suite 的第一枚锚点

## 4. 最常见的五类蓝图失焦

| 失焦方式 | 会造成什么问题 |
| --- | --- |
| 先写很多容易的 happy-path test | 最贵失真仍无护栏 |
| 先追求覆盖率再追求优先级 | 测试预算被摊薄 |
| 不先定义 first test | suite 迟迟无法落地 |
| 不给 rollout order | 蓝图无法执行 |
| 只列 suite 不列 minimal assertion | 测试容易写成空壳 |

## 5. 一条硬结论

对安全控制面来说，  
真正可执行的蓝图不是：

`列出很多以后要补的测试，`

而是：

`为每一类最高优先级风险都指定第一条该先写的测试、它要守住的最小断言，以及明确的落地顺序。`
