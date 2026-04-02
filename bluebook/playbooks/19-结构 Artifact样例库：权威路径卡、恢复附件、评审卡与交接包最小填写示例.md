# 结构 Artifact样例库：权威路径卡、恢复附件、评审卡与交接包最小填写示例

这一章不再解释结构 artifact contract 为什么需要，而是直接给出四类工件的最小填写样例。

它主要回答四个问题：

1. 结构 artifact contract 真正填出来时长什么样。
2. 宿主卡、CI附件、评审卡与交接包怎样共享同一 structure object header。
3. 怎样避免样例重新退回目录图、恢复成功率、规则说明与作者讲解。
4. 怎样让后来者直接照着填，而不是继续从空白表格起步。

## 0. 第一性原理

结构样例层真正要展示的，不是：

- 四份看起来都很专业的结构材料

而是：

- 同一份 structure object contract 被四类工件按不同粒度投影出来的最小形式

所以这组样例都遵守同一个原则：

- 先共享对象级真相，再分化角色

## 1. Shared Header 最小样例

```text
artifact_header:
- artifact_line_id: STR-ART-003
- structure_object_type: bridge_session_pointer
- structure_object_id: bridge:pointer-17
- authoritative_path: bridge_pointer -> session_ingress
- current_read_path: host_card -> projection_view
- current_write_path: bridge_pointer -> authority_surface
- projection_set: host_card, ui_panel, recovery_view
- recovery_asset_ledger: pointer,snapshot,replacement_log
- anti_zombie_evidence: generation_guard + stale_drop
- retained_assets: pointer,snapshot,rollback_marker
- danger_paths: stale_pointer_write, split_projection_refresh
- rollback_object: bridge:pointer-17
- dropped_stale_writers: stale_bridge_writer@gen-16
```

这组字段是四类工件都要继承的最小前缀。

## 2. 宿主卡最小填写示例

```text
host_card:
- artifact_line_id: STR-ART-003
- structure_object_id: bridge:pointer-17
- authoritative_path: bridge_pointer -> session_ingress
- current_recovery_state: healthy
- rollback_object: bridge:pointer-17
- danger_paths: stale_pointer_write, split_projection_refresh
- next_action: continue_normal_projection_read
```

宿主卡的目标不是：

- 展示目录图

而是：

- 让当前对象、当前权威路径与当前回退对象在前台可见

## 3. CI 附件最小填写示例

```text
ci_attachment:
- artifact_line_id: STR-ART-003
- recovery_asset_ledger: pointer,snapshot,replacement_log
- anti_zombie_evidence: generation_guard + stale_drop
- retained_assets: pointer,snapshot,rollback_marker
- dropped_stale_writers: stale_bridge_writer@gen-16
- recovery_drill_result: pass
- hard_fail_result: none
```

CI 附件的目标不是：

- 宣布恢复通过

而是：

- 解释为什么当前 structure object 仍然只有一条合法真相路径

## 4. 评审卡最小填写示例

```text
review_card:
- artifact_line_id: STR-ART-003
- authoritative_path: bridge_pointer -> session_ingress
- current_read_path: host_card -> projection_view
- current_write_path: bridge_pointer -> authority_surface
- projection_set: host_card, ui_panel, recovery_view
- rollback_object: bridge:pointer-17
- authority_judgement: 当前无第二写路径
- rollback_judgement: 如恢复异常，回退到 pointer object 而不是文件级 rollback
```

评审卡的目标不是：

- 再画一版结构图

而是：

- 沿 shared header 对当前 structure object 给出 judgement

## 5. 交接包最小填写示例

```text
handoff_package:
- artifact_line_id: STR-ART-003
- structure_object_id: bridge:pointer-17
- retained_assets: pointer,snapshot,rollback_marker
- danger_paths: stale_pointer_write, split_projection_refresh
- rollback_object: bridge:pointer-17
- dropped_stale_writers: stale_bridge_writer@gen-16
- handoff_notes: 接手者无需问作者，沿 authoritative path 与 rollback object 即可继续判断
```

交接包的目标不是：

- 复述作者经验

而是：

- 交出对象、资产和危险路径

## 6. 三个最容易抄坏的地方

1. 把宿主卡退回目录图或文件 diff，而不是 authoritative path 的当前投影。
2. 把 CI 附件退回恢复成功率，而不是 recovery asset ledger + anti-zombie evidence。
3. 把交接包退回作者说明，而不是 retained assets + rollback object + danger paths。

## 7. 苏格拉底式追问

在你准备照抄这组样例前，先问自己：

1. 我抄到的是 shared header，还是只抄到一份结构化展示。
2. 这四类工件是否都仍然围绕同一个 structure object。
3. 如果删掉作者讲解，后来者还能否继续。
4. 我是在压缩结构真相表达，还是在删掉结构真相本身。
