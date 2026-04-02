# 结构 Artifact Validator模板：权威路径、恢复资产、anti-zombie 与交接拒收

这一章不再解释结构 artifact 为什么重要，而是把它压成团队可复用 validator / linter 模板。

它主要回答五个问题：

1. 怎样判断结构 artifact 是否真的围绕同一 `structure object`、同一 `authoritative path` 与同一 `rollback object` 成立，而不是围绕目录图、恢复成功率与作者说明成立。
2. 怎样把 `shared header`、`recovery asset ledger`、`anti-zombie evidence` 与 `handoff reject rule` 放进同一张校验卡。
3. 怎样让宿主、CI、评审与交接沿同一校验顺序消费结构 artifact。
4. 怎样识别“权威路径写了、恢复通过了、规则也有了、作者也解释了”这类看似合规的漂移。
5. 怎样用苏格拉底式追问避免把结构 validator 退回目录审美或作者权威。

## 0. 代表性源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- 源码先进性不是结构更好看，而是权威路径、恢复资产、反 zombie 证据与对象级回退能被非作者沿同一骨架持续验证。

## 1. 第一性原理

更成熟的结构 validator 不是：

- 规则更多

而是：

- 一旦结构对象裂开、旧 writer 未死、恢复资产不明，系统会比作者说明更早阻断继续

所以审读结构 artifact 时，最该先问的不是：

- 结构图是不是更清楚

而是：

- 当前这四类工件是否仍然共享同一 `structure_object_id`

## 2. Structure Validator Header

任何结构 artifact validator 都先锁这一组 shared header：

```text
artifact_line_id:
structure_object_type:
structure_object_id:
authoritative_path:
current_read_path:
current_write_path:
projection_set:
recovery_asset_ledger:
anti_zombie_evidence:
retained_assets:
dropped_stale_writers:
danger_paths:
rollback_object:
```

团队规则：

1. 没有 `authoritative_path` 的结构卡，直接 `hard fail`。
2. 没有 `recovery_asset_ledger` 的恢复结果，不能冒充正式恢复证据。
3. 没有 `dropped_stale_writers`、`danger_paths` 与 `rollback_object` 的 handoff，直接 `reject`。
4. 四类工件的 `structure_object_id`、`authoritative_path` 不一致，直接判定 `structure split-brain`。

## 3. Authority Path Gate

先审当前权威路径是不是活的运行时事实：

```text
[ ] authoritative_path 是否点名
[ ] current_read_path / current_write_path 是否点名
[ ] projection_set 是否点名
[ ] 旧路径是否仍可写已点名
[ ] 是否避免用目录图替代 authoritative_path
```

直接判 drift 的情形：

1. 权威路径卡只有目录图或模块图，没有当前读写路径。
2. `authoritative_path` 已命名，但旧 writer 仍可写。
3. 宿主卡看起来完整，但 `structure_object_id` 和评审卡、交接包不一致。

## 4. Recovery Asset Gate

任何恢复附件都必须证明恢复靠什么成立，而不是只报喜：

```text
[ ] recovery_asset_ledger 是否存在
[ ] retained_assets 是否存在
[ ] stale state 的处理规则是否存在
[ ] rollback_object 是否能解释恢复边界
[ ] 成功率之外是否仍保留对象级证据
```

团队规则：

1. “恢复通过”不能替代 `recovery_asset_ledger`。
2. “成功率不错”不能替代 `retained_assets`。
3. “作者知道怎么恢复”不能替代正式台账。

## 5. Anti-Zombie Gate

任何结构 artifact 都要单独审 stale writer 是否真的死掉：

```text
[ ] anti_zombie_evidence 是否存在
[ ] dropped_stale_writers 是否存在
[ ] 旧 projection 是否仍可回写已点名
[ ] danger_paths 是否已列入交接
[ ] 规则是否真的绑定当前 structure object
```

核心原则不是：

- 有 anti-zombie 规则就算安全

而是：

- 旧 writer 必须被正式证明无法继续夺权

## 6. Review / Handoff Reject Gate

评审与交接必须围绕同一结构对象继续判断：

```text
[ ] review judgement 是否回链到 authoritative_path
[ ] review judgement 是否回链到 current_read_path / current_write_path
[ ] handoff 是否写清 retained_assets
[ ] handoff 是否写清 danger_paths
[ ] handoff 是否写清 rollback_object 与 dropped_stale_writers
```

直接拒收条件：

1. 交接包只有作者说明，没有 `danger_paths`。
2. 交接包没有 `rollback_object`，却要求后来者继续恢复。
3. 评审卡只有“结构更清晰”，没有 `authoritative_path` 与当前读写路径。

## 7. Validator 输出等级

```text
HARD FAIL:
- structure_object_id 缺失或跨工件不一致
- authoritative_path 缺失
- recovery_asset_ledger 缺失

LINT WARN:
- 目录图大于对象锚点
- 恢复附件只有成功率
- anti-zombie 只有规则没有清退证据

REWRITE TARGET:
- authority path card / recovery attachment / review card / handoff package
```

真正成熟的结构 validator 不只是：

- 让结构说明写得更清楚

而是：

- 让目录图、报喜与口头交接无法再冒充对象级结构真相

## 8. 苏格拉底式检查清单

在你准备宣布“结构 artifact validator 已经成立”前，先问自己：

1. 我现在验证的是同一 `structure_object_id`，还是几份相关但分裂的结构材料。
2. 恢复成功是否真的绑定了 `recovery_asset_ledger`。
3. anti-zombie 证据约束的是旧 writer 死亡，还是只是一条写在文档里的原则。
4. rollback object 是否已经比作者口头说明更早被交付。
5. 如果删掉原作者，这四类工件是否仍能让后来者沿同一结构对象继续。
