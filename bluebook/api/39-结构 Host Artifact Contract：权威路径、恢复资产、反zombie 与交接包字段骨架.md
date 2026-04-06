# 结构 Host Artifact Contract：权威路径、恢复资产、反zombie 与交接包字段骨架

这一章回答五个问题：

1. 结构线的宿主卡、CI 附件、评审卡与交接包，到底该共享哪条正式对象链。
2. 哪些字段是 hard contract，哪些只是 role-specific projection，哪些仍只能停留在 internal hint。
3. 为什么结构工件必须先围绕 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`，而不是围绕结构图、恢复成功率与作者说明。
4. 哪些字段最适合写成 hard contract，缺失时必须直接判定工件不合法。
5. 宿主开发者与平台设计者该按什么顺序接入这套结构 artifact contract。

## 0. 第一性原理

结构线真正成熟的 artifact contract，不是四类角色各自维护结构图、恢复日志和交接说明，而是四类工件共享同一条源码真相链：

1. `contract`
2. `registry`
3. `current-truth surface`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

旧结构名词只能降回这条链上的局部见证：

1. `authoritative path`
   - 只是 `current-truth surface` 的 read/write witness。
2. `recovery asset`
   - 只是 current-truth 恢复与 mirror gap 的 evidence carrier。
3. `anti-zombie evidence`
   - 只是 `hotspot kernel` 的 freshness witness。
4. `danger paths`
   - 只是 `mirror gap discipline` 的风险注记。
5. `rollback object`
   - 只是结构恢复时的 cleanup carrier。

## 1. Shared Header

更稳的结构 artifact header 至少应共享：

```text
artifact_header:
- artifact_line_id
- structure_object_type
- structure_object_id
- contract_ref
- registry_ref
- current_truth_surface_ref
- consumer_subset_ref
- hotspot_kernel_ref
- mirror_gap_ref
- one_writable_present_witness
- retained_assets
- dropped_stale_writers
- reject_verdict
- next_action
```

这份 header 的作用不是：

- 取代结构图、恢复日志和交接说明

而是：

- 让四类工件都从同一条源码真相链起手

## 2. 四类工件的最小投影

### 2.1 宿主卡

最少字段：

1. `structure_object_id`
2. `current_truth_surface_ref`
3. `consumer_subset_ref`
4. `one_writable_present_witness`
5. `next_action`

禁止退化为：

- 只有目录图
- 只有文件 diff

### 2.2 CI 附件

最少字段：

1. `registry_ref`
2. `current_truth_surface_ref`
3. `hotspot_kernel_ref`
4. `retained_assets`
5. `dropped_stale_writers`
6. `reject_verdict`

禁止退化为：

- 只有恢复成功率
- 只有“看起来 fail-closed”

### 2.3 评审卡

最少字段：

1. `contract_ref`
2. `registry_ref`
3. `current_truth_surface_ref`
4. `consumer_subset_ref`
5. `one_writable_present_witness`
6. `review_judgement`

禁止退化为：

- 先看结构图，再补 live path
- 先看作者说明，再补 reject path

### 2.4 Handoff Package

最少字段：

1. `structure_object_id`
2. `current_truth_surface_ref`
3. `mirror_gap_ref`
4. `retained_assets`
5. `dropped_stale_writers`
6. `later_reject_path`

禁止退化为：

- 只有作者讲解
- 只有危险路径口头说明

## 3. Hard Contract 与 Reject Trio

最应写成 hard contract 的字段：

1. `structure_object_id`
2. `contract_ref`
3. `registry_ref`
4. `current_truth_surface_ref`
5. `consumer_subset_ref`
6. `hotspot_kernel_ref`
7. `mirror_gap_ref`
8. `one_writable_present_witness`
9. `reject_verdict`

结构线最值得长期复用的 reject trio 是：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

只要工件不能直接指出自己正在违反哪一类 reject，它就还不是 later maintainer 可复用的 artifact contract。

## 4. 为什么 current-truth surface 必须先于恢复资产

因为结构先进性真正要回答的不是：

- 看起来是不是更整洁
- 恢复是不是成功过一次

而是：

- 现在谁有权写现在

如果工件围绕的不是 `current-truth surface`：

1. 宿主卡会退回目录图。
2. CI 附件会退回恢复结果面。
3. 评审卡会退回作者权威。
4. handoff package 会退回口头交接。

也就是说，`recovery asset` 只能帮助找回 current truth，不能升级成第二主权面。

## 5. 最小接入顺序

如果你要最小化接入结构 artifact contract，建议按下面顺序做：

1. 先固定 `contract_ref -> registry_ref -> current_truth_surface_ref`。
2. 再把 `consumer_subset_ref` 与 `mirror_gap_ref` 补出来，防止可见面冒充真相。
3. 再把 `hotspot_kernel_ref` 与 `one_writable_present_witness` 接进来，说明哪些复杂度是合法集中。
4. 最后才把 retained assets、stale writers 与 handoff fields 作为 evidence carrier 补齐。

不要反过来：

1. 先做结构图
2. 先做恢复日志
3. 先做交接包模板

那样只会把投影写得更丰富，却仍然保不住源码主语。

## 6. 苏格拉底式追问

在你准备宣布“结构 artifact contract 已经稳定”前，先问自己：

1. 我共享的是同一条源码真相链，还是四份角色各自的结构摘要。
2. `authoritative path` 在这里还是 live read/write witness，还是已经被读成抽象路径口号。
3. `recovery asset` 在这里是在帮助找回 current truth，还是已经越权成第二主权面。
4. later maintainer 是否能不问作者就指出 first reject path。
5. 这些热点到底是在合法集中复杂度，还是只是在逃避拆分。

## 7. 一句话总结

结构 Host Artifact Contract 真正统一的，不是四类工件的展示格式，而是它们都必须从 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline` 这条源码真相链起手，再把旧结构名词降回局部见证。
