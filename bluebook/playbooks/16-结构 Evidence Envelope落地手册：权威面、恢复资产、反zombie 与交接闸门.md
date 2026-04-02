# 结构 Evidence Envelope落地手册：权威面、恢复资产、反zombie 与交接闸门

这一章不再解释结构 evidence envelope 应该长什么样，而是把它压成宿主、CI、评审与交接都能直接执行的一套落地手册。

它主要回答五个问题：

1. 结构线真正的 host implementation playbook 到底该检查什么。
2. authority surface、recovery asset、anti-zombie gate 与 rollback object 该怎样被不同角色共同消费。
3. 哪些检查最适合写成 handoff gate，哪些最适合写成 CI gate。
4. 怎样避免结构升级再次退回文件级回退、目录美观与作者记忆。
5. 怎样用苏格拉底式追问避免把这章写成结构洁癖清单。

## 0. 改写前状态

没有结构 host implementation playbook 的团队，最常见状态是：

1. 宿主只知道哪些文件变了。
2. CI 只看目录变化或部分恢复成功率。
3. 评审只看结构图和作者解释。
4. 交接主要靠作者口头说明 danger paths。
5. 结构升级一到回退就退回文件级 rollback。

## 1. 目标状态

迁移后的目标不是：

- 再做一张结构图

而是：

1. 宿主消费当前 object、authority surface 与 current truth。
2. CI 校验 recovery asset、anti-zombie gate 与 rollback boundary。
3. 评审先看 authority / recovery / rollback，再看目录与文件。
4. 交接拿到 retained assets、danger paths 与 rollback object。
5. 四类角色围绕同一结构 envelope 骨架判断。

## 2. 最小落地 diff

### 改写前

```text
宿主:
- 展示文件变更

CI:
- 看目录 / 恢复成功率

评审:
- 看结构图 / 作者说明

交接:
- 问作者哪里危险
```

### 改写后

```text
宿主:
- 展示 current object / authority surface / projection set

CI:
- 检查 recovery asset / anti-zombie gate / rollback object

评审:
- 先看 authority / recovery / rollback，再看文件与目录

交接:
- 先看 retained assets / danger paths / rollback object
```

### 这段 diff 的意义

真正的变化不是：

- 多了几张结构说明图

而是：

- 结构判断终于围绕对象真相，而不是围绕文件表面

## 3. 角色检查点

### 3.1 宿主最小检查点

宿主至少必须消费：

1. current object
2. authority surface
3. projection set
4. current recovery state
5. rollback object

硬要求：

- 宿主不能只展示文件 diff 或目录变化。

### 3.2 CI 最小检查点

CI 至少必须检查：

1. authority surface 是否已点名。
2. recovery asset ledger 是否完整。
3. anti-zombie gate 是否存在。
4. rollback object boundary 是否明确。
5. retained assets 是否已定义。

硬门禁：

- authority surface 缺失
- recovery asset 缺失
- anti-zombie gate 缺失
- rollback object 缺失

### 3.3 评审最小检查点

评审至少必须先看：

1. authority surface
2. projection set
3. recovery asset
4. anti-zombie gate
5. rollback object boundary

软检查点：

- 文件 diff 是否符合对象边界
- 目录图是否真正服务 authority / recovery

禁止事项：

- 只凭目录美观或文件拆分评价结构升级

### 3.4 交接最小检查点

交接至少必须交付：

1. current object
2. authority surface
3. retained assets
4. danger paths
5. rollback object
6. dropped stale writers

硬要求：

- 交接不能只靠作者记忆或结构图。

## 4. 统一检查顺序

结构线四类角色更稳的统一顺序是：

1. 当前对象
2. authority surface
3. projection set
4. recovery assets
5. anti-zombie gate
6. rollback boundary

## 5. 结构线硬门禁

下面这些最适合写成硬门禁：

1. `authority surface` 缺失。
2. `recovery_asset` 缺失。
3. `anti_zombie_gate` 缺失。
4. `rollback_object_boundary` 缺失。
5. `retained_assets` 缺失。

## 6. handoff gate

结构线最适合写成 handoff gate 的检查点是：

1. danger paths 是否点名。
2. retained assets 是否点名。
3. dropped stale writers 是否点名。
4. rollback object 是否点名。

如果这四项缺任何一项，交接应视为：

- 仍然依赖作者记忆

## 7. 苏格拉底式追问

在你准备宣布结构 host implementation 已落地前，先问自己：

1. 宿主、CI、评审与交接是不是都先围绕 authority / recovery / rollback 判断。
2. 我保住的是对象真相，还是只保住了文件与目录表面。
3. 任何一个角色现在还能不能只凭结构图或作者解释给出结论。
4. 如果今天发生回退，我知道该退回哪个对象，而不是只知道该回退哪些文件吗。
