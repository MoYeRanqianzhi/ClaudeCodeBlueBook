# 安全状态句柄化速查表：current carrier、missing scope、recommended handle fields与migration gain

## 1. 这一页服务于什么

这一页服务于 [80-安全状态句柄化：为什么下一代控制面不该继续用裸key编辑状态，而应把family scope升级为opaque handle](../80-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E5%8F%A5%E6%9F%84%E5%8C%96%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8B%E4%B8%80%E4%BB%A3%E6%8E%A7%E5%88%B6%E9%9D%A2%E4%B8%8D%E8%AF%A5%E7%BB%A7%E7%BB%AD%E7%94%A8%E8%A3%B8key%E7%BC%96%E8%BE%91%E7%8A%B6%E6%80%81%EF%BC%8C%E8%80%8C%E5%BA%94%E6%8A%8Afamily%20scope%E5%8D%87%E7%BA%A7%E4%B8%BAopaque%20handle.md)。

如果 `80` 的长文解释的是：

`为什么 family scope 的下一步应是 handle，而不是继续堆命名约定，`

那么这一页只做一件事：

`把当前 carrier、缺失的 scope、推荐 handle 字段与迁移收益压成一张句柄化矩阵。`

## 2. 状态句柄化矩阵

| subsystem | current carrier | missing scope | 推荐 handle 字段 | migration gain | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| notifications identity | `key: string` | family、owner、allowed operator | `family`、`member`、`owner`、`allowedOperators` | 从名字寻址升级成能力寻址 | `notifications.tsx:6-23,31-40,193-213` |
| notifications store | `current / queue` 中的裸 `Notification` | scope metadata、family relation、editor rights | `scopeId`、`familyMeta`、`relationMeta` | store 不再丢失作用域信息 | `AppStateStore.ts:222-225,532-535` |
| family-driven replace logic | key 前缀 + 文件边界 | family object、本地可验证作用域 | `familyHandle`、`memberHandle` | 不再只靠命名纪律维持边界 | `useFastModeNotification.tsx:8-11`、`useIDEStatusIndicator.tsx:88-149`、`useTeammateShutdownNotification.ts:24-45` |
| bridge control plane | `ReplBridgeHandle` | 已较完整，仅可继续扩展 provenance | `sessionId`、transport-bound methods、`teardown` | 已证明 handle 能承载上下文和能力边界 | `replBridge.ts:70-80,1779-1834` |
| bridge handle global pointer | 全局保存 `ReplBridgeHandle` | 相比通知面，缺口更小 | handle provenance、creator-bound closure | 避免独立重建 session/token 上下文 | `replBridgeHandle.ts:5-27` |

## 3. 最短判断公式

看到一个状态编辑接口时，先问四句：

1. 当前 carrier 只是名字，还是已经是 capability object
2. 它有没有把 family 和 owner 一起带进来
3. 如果调用方只知道名字，能不能越过作用域边界做编辑
4. 把它升级成 handle 后，首先减少的是哪类误删、误废止或误聚合风险

## 4. 最常见的五类句柄缺失风险

| 缺失风险 | 会造成什么问题 |
| --- | --- |
| 只有 key 没有 family | 作用域边界停留在命名约定 |
| 只有 key 没有 owner | 谁都能理论上删除谁 |
| 只有 key 没有 allowedOperators | fold / invalidate / remove 难以被接口限制 |
| store 不保存 scope metadata | 上层知道的边界进 store 后消失 |
| 明明已有 handle 经验却不迁移 | 同一代码库内边界成熟度长期失衡 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
当系统已经开始认真对待状态主权时，  
最自然的下一步不是更多命名规则，  
而是：

`把状态边界从字符串提升成句柄。`
