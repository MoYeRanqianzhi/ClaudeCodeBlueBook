# 宿主接入审读导航：message lineage、governance key 与 authority object 如何进入持续排查

宿主接入排查真正要固定的，不是若干支持面名词，而是三条宿主消费链：

- Prompt: `message lineage -> projection consumer -> protocol transcript -> continuation object -> continuation qualification`
- Governance: `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing`
- Structure: `authority object -> per-host authority width -> authoritative path -> freshness gate -> stale worldview / ghost capability -> anti-zombie evidence`

## 1. Prompt 宿主接入审读线

优先排查这些对象：

1. 宿主是否围绕 `message lineage` 而不是 prompt 字符串工作。
2. 宿主是否把 display、model API、SDK/control 与 handoff/resume 吃成不同 `projection consumer`。
3. 宿主是否围绕 `protocol transcript` 与 `continuation qualification` 判断当前是否还能继续。

阅读顺序：

1. `../playbooks/29`
2. `../casebooks/25`
3. `../api/51`

如果排查开始退回“看起来接上了”“缓存大致没坏”或字符串补丁，说明宿主正在重新把 Prompt 魔力读回文案层。

## 2. 治理宿主接入审读线

优先排查这些对象：

1. 宿主是否围绕 `governance key` 而不是 mode 面板工作。
2. 宿主是否沿 `externalized truth chain` 消费 effective truth，而不是自己拼当前世界。
3. ask 是否仍按 `typed ask` 事务被消费。
4. `decision window` 与 `continuation pricing` 是否仍在解释为什么当前该继续或拒收。

阅读顺序：

1. `../playbooks/30`
2. `../casebooks/26`
3. `../api/52`

如果排查开始退回审批历史、token 条或文件级回退说明，说明宿主正在把统一定价治理重新读回投影替身。

## 3. 结构宿主接入审读线

优先排查这些对象：

1. 宿主是否仍围绕 `authority object` 消费当前真相。
2. 宿主是否只消费合法 `per-host authority width`。
3. 当前 present truth 是否仍沿正式 `authoritative path` 外化。
4. `freshness gate` 是否仍先于恢复叙事发挥作用。
5. stale worldview / ghost capability 与 `anti-zombie evidence` 是否仍对宿主可见。

阅读顺序：

1. `../playbooks/31`
2. `../casebooks/27`
3. `../api/53`

如果排查开始退回 pointer 崇拜、恢复成功率、spinner 平静感或作者补叙，说明结构宿主接入已经在消费假信号。

## 4. 为什么这层更适合落在 playbooks

因为这一层真正要固定的不是字段定义，而是：

1. 团队排查时先回哪个对象链。
2. 哪些症状足以直接拒收宿主接法。
3. 哪些演练最能暴露宿主仍在消费假信号。
4. drift 发生后怎样围绕同一对象链记录、修复与防再发。

## 5. 苏格拉底式自检

在你准备宣布“宿主接入已经稳定”前，先问自己：

1. 我是否已经知道宿主接错时先回哪个对象、哪个窗口、哪个边界。
2. 哪些坏接法应直接拒收，而不是继续修补。
3. later 漂移发生时，CI、交接与宿主是否还能围绕同一审读顺序复盘。
4. 我是在写一份运维清单，还是在保护同一机制对象的长期宿主消费。
