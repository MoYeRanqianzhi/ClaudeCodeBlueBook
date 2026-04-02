# 安全验证覆盖缺口与优先级速查表：area、historical signal、recommended test type与priority

## 1. 这一页服务于什么

这一页服务于 [113-安全验证覆盖缺口与优先补强路线：为什么不是所有tests都该同时补，而应先覆盖最贵的失真与最脆的时序](../113-%E5%AE%89%E5%85%A8%E9%AA%8C%E8%AF%81%E8%A6%86%E7%9B%96%E7%BC%BA%E5%8F%A3%E4%B8%8E%E4%BC%98%E5%85%88%E8%A1%A5%E5%BC%BA%E8%B7%AF%E7%BA%BF%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E6%89%80%E6%9C%89tests%E9%83%BD%E8%AF%A5%E5%90%8C%E6%97%B6%E8%A1%A5%EF%BC%8C%E8%80%8C%E5%BA%94%E5%85%88%E8%A6%86%E7%9B%96%E6%9C%80%E8%B4%B5%E7%9A%84%E5%A4%B1%E7%9C%9F%E4%B8%8E%E6%9C%80%E8%84%86%E7%9A%84%E6%97%B6%E5%BA%8F.md)。

如果 `113` 的长文解释的是：

`测试优先级应按最贵失真排序，`

那么这一页只做一件事：

`把各 area 当前的历史信号、最该补的测试类型与优先级压成一张路线矩阵。`

## 2. 覆盖缺口优先级矩阵

| area | historical signal | recommended test type | priority | 关键证据 |
| --- | --- | --- | --- | --- |
| permission mode + metadata sync | 过去 8+ mutation paths 中多数不会正确同步 external metadata | integration ordering + diff propagation tests | P0 | `onChangeAppState.ts:50-64`; `useReplBridge.tsx:417-453`; `permissionSetup.ts:597-645` |
| notifications stale actor / duplicate family | current-key compare、duplicate prevention、absent-remove 全靠局部 guard | property tests + table tests | P1 | `notifications.tsx:54-68,172-188,193-212` |
| bridge retry/fuse/timer | 401 storm 前科、cancelled throw spurious state、stale error 注释 | property tests + threshold tables | P1 | `useReplBridge.tsx:31-40,616-644` |
| plugin refresh lifecycle | stale-cache bug、race、issue #15521、禁止 auto-reset | transition-table + stale-cache regression tests | P2 | `useManagePlugins.ts:289-302`; `refresh.ts:81-88,140-145` |
| pointer resumability branches | stale/invalid clear、transient vs fatal 分支语义很重 | branch matrix + TTL boundary tests | P2 | `bridgePointer.ts:83-109`; `bridgeMain.ts:1525-1537,2384-2403,2524-2534` |
| low-level store no-op | 只有 `Object.is(next, prev)` 的薄约束 | basic invariant unit tests | P3 | `store.ts:20-27` |
| test infrastructure itself | 本地高风险模块 conventional test/spec 检索为 0 | establish harness + first golden suite | P0/P1 foundation | 本地检索 `rg ... (__tests__|.test.|.spec.) => 0` |

## 3. 最短判断公式

决定先补哪类测试时，先问五句：

1. 这里是否已有历史 bug/race 注释
2. 这里退化后会不会让多个 surface 同时失真
3. 这里是否主要是时序问题而不是纯函数问题
4. 这里最适合 property、table 还是 integration
5. 这里若不先补，未来重构最容易破坏什么

## 4. 最常见的五类优先级误判

| 误判方式 | 会造成什么问题 |
| --- | --- |
| 按模块平均补测试 | 最贵风险仍然裸奔 |
| 优先补最容易写的 happy-path | 最脆的时序漏洞继续无护栏 |
| 忽略注释里的 bug 前科 | 已知会复发的路径仍无人看守 |
| 只补 unit test 不补 ordering/property | 宪法类规则难被持续证明 |
| 不先建最小测试骨架 | 后续所有优先级规划都落不了地 |

## 5. 一条硬结论

对安全控制面来说，  
真正合理的测试投资不是：

`哪里空就先补哪里，`

而是：

`先把那些一旦退化就最容易制造高成本真相失真的路径，用最合适的测试类型优先钉死。`
