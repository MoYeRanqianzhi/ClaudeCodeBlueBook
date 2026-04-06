# 宿主验收执行导航：message lineage、governance key 与 authority object 如何进入执行卡

宿主验收执行层真正要固定的，不是更细的表单，而是三条 shared execution chain：

- Prompt: `message lineage -> projection consumer -> protocol transcript -> continuation object -> continuation qualification -> reject / rollback`
- Governance: `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> cleanup / rollback`
- Structure: `authority object -> writeback path -> freshness gate -> stale worldview / ghost capability -> anti-zombie evidence -> reopen`

## 1. Prompt 宿主验收执行线

优先执行这些顺序：

1. 先验 `message lineage`
2. 再验 `projection consumer`
3. 再验 `protocol transcript`
4. 最后验 `continuation object / continuation qualification / rollback`

阅读顺序：

1. `../api/54`
2. `../playbooks/35`
3. `../casebooks/28`
4. `../guides/57`

如果执行开始退回 prompt 截图、摘要交接与最后一条消息判断，说明 Prompt 验收已经回到展示层。

## 2. 治理宿主验收执行线

优先执行这些顺序：

1. 先验 `governance key`
2. 再验 `externalized truth chain`
3. 再验 `typed ask`
4. 再验 `decision window`
5. 最后验 `continuation pricing / cleanup / rollback`

阅读顺序：

1. `../api/55`
2. `../playbooks/36`
3. `../casebooks/29`
4. `../guides/58`

如果执行开始退回 mode 面板、审批弹窗与 token 仪表盘，说明治理验收已经退回交互投影。

## 3. 结构宿主验收执行线

优先执行这些顺序：

1. 先验 `authority object`
2. 再验 `writeback path`
3. 再验 `freshness gate`
4. 再验 stale worldview / ghost capability
5. 最后验 `anti-zombie evidence / reopen boundary`

阅读顺序：

1. `../api/56`
2. `../playbooks/37`
3. `../casebooks/30`
4. `../guides/59`

如果执行开始退回 pointer、成功率与作者口述，说明结构验收已经在围绕假信号做决定。

## 4. 为什么这层更适合落在 playbooks

因为这一层真正要固定的是：

1. 现场先看哪一个对象。
2. 看见什么必须立刻拒收。
3. 谁有权宣布继续、停止灰度或进入回退。
4. 回退到底回到哪个对象边界，而不是回到哪几句说明。

## 5. 第一性原理与苏格拉底式自检

在你准备宣布“宿主验收执行层已经完整”前，先问自己：

1. 我写的是对象级执行顺序，还是一套更细的经验判断。
2. 这些 reject verdict 能否被宿主、CI、评审与交接系统共享，而不是各自翻译一次。
3. 当前判断主体到底是谁，消费的到底是哪一个对象。
4. 当前拒收之后，回退的是正式对象边界，还是某种 UI 成功感。
