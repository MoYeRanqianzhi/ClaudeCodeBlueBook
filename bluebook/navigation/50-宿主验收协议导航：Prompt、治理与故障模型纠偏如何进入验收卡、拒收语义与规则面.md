# 宿主验收协议导航：message lineage、governance key 与 authority object 如何进入验收卡

宿主验收协议真正要固定的，不是更细的字段清单，而是三条 host-consumable contract chain：

- Prompt: `message lineage -> projection consumer -> protocol transcript -> continuation object -> continuation qualification`
- Governance: `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable/transient cleanup`
- Structure: `authority object -> per-host authority width -> writeback path -> freshness gate -> anti-zombie evidence -> reopen boundary`

## 1. Prompt 宿主验收协议线

优先看这些 contract 对象：

1. `message lineage`
2. `projection consumer`
3. `protocol transcript`
4. `continuation object`
5. `continuation qualification`

阅读顺序：

1. `../api/54`
2. `../guides/57`
3. `../casebooks/28`

如果验收协议开始退回截图、摘要或 token 曲线，说明 Prompt 世界已经重新长出第二真相。

## 2. 治理宿主验收协议线

优先看这些 contract 对象：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `durable/transient cleanup`

阅读顺序：

1. `../api/55`
2. `../guides/58`
3. `../casebooks/29`

如果验收协议开始退回 mode 面板、弹窗与 token 仪表盘，说明治理对象已经退回交互投影。

## 3. 结构宿主验收协议线

优先看这些 contract 对象：

1. `authority object`
2. `per-host authority width`
3. `writeback path`
4. `freshness gate`
5. `anti-zombie evidence`
6. `reopen boundary`

阅读顺序：

1. `../api/56`
2. `../guides/59`
3. `../casebooks/30`

如果验收协议开始退回 pointer、成功率与作者口述，说明恢复资产已经篡位、writeback 已经分叉或 anti-zombie 结果面已经缺席。

## 4. 为什么这层更适合落在 api

因为这里真正要固定的不是“先修什么”，而是：

1. 哪些对象必须被宿主正式消费。
2. 哪些字段必须是必填，而不是建议项。
3. 哪些 reject verdict 应该跨宿主、CI、评审与交接共享。
4. 哪些内部实现不应被抬升成公共契约。

## 5. 苏格拉底式自检

在你准备宣布“宿主验收协议已经完整”前，先问自己：

1. 我定义的是对象级 contract，还是一组更细的经验判断。
2. 这些 reject verdict 能否跨宿主、CI、评审与交接共享。
3. 宿主消费的是正式规则面，还是内部实现偶然泄漏出来的细节。
4. 如果 later 内部重构发生，这套验收协议是否仍然成立。
