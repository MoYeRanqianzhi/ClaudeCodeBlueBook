# history paging sentinel split 拆分记忆

## 本轮继续深入的核心判断

58、118、121、123 已经把 attached viewer 的 ownership、dedup、init restore 拆开了。

但正文还缺一条更细的 surface 结论：

- transcript 顶部 paging sentinel 不是 remote presence ledger

本轮要补的更窄一句是：

- `loading older messages… / failed to load older messages / start of session` 属于 attached viewer 内部的分页哨兵，不属于 `remoteConnectionStatus / remoteBackgroundTaskCount` 那张存在面

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把顶部 `loading older` 写成 reconnect
- 把 `start of session` 写成远端当前 idle / connected
- 把 brief warning 写成 history paging 的另一种显示

这三种都会把：

- transcript paging
- scroll geometry
- remote live presence

重新压扁。

## 本轮最关键的新判断

### 判断一：assistant attach 的 history 从入口层就是 scroll-up lazy load

### 判断二：`useAssistantHistory` 自带独立分页状态机

### 判断三：`SENTINEL_LOADING` / `FAILED` / `START` 只回答 older-page paging 问题

### 判断四：`anchorRef` / `fillBudgetRef` 处理的是滚动几何，不是 runtime health

### 判断五：`remoteConnectionStatus` / `remoteBackgroundTaskCount` 才是 remote presence ledger

### 判断六：`BriefIdleStatus` 只是 presence ledger 的 brief consumer

## 苏格拉底式自审

### 问：为什么这页不是 58 的 history 补充段？

答：因为 58 还在 ownership / first-load / title 这组合同里，这页只抓分页哨兵与 presence surface 的边界。

### 问：为什么一定要把 `BriefIdleStatus` 写进来？

答：因为它构成最干净的对照 consumer，证明 presence 面根本不读 paging sentinel。

### 问：为什么一定要把 `fillBudgetRef` 拉进来？

答：因为它让这条线从“文案”上升成“分页几何状态机”，边界会更稳。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/153-SENTINEL_LOADING、SENTINEL_LOADING_FAILED、SENTINEL_START、maybeLoadOlder、fillBudgetRef、remoteConnectionStatus 与 BriefIdleStatus：为什么 attached viewer 的历史翻页哨兵不是 remote presence surface.md`
- `bluebook/userbook/03-参考索引/02-能力边界/142-SENTINEL_LOADING、SENTINEL_LOADING_FAILED、SENTINEL_START、useAssistantHistory、remoteConnectionStatus 与 BriefIdleStatus 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/153-2026-04-08-history paging sentinel split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 153
- 索引层只补 142
- 记忆层只补 153

不回写 58、118、121、123、151。

## 下一轮候选

1. 单独拆 `claude assistant` 的 discovery / install wizard / chooser / attach 四段入口链。
2. 单独拆 attached viewer 的分页哨兵与 `SessionPreview` / session list 的 durable transcript consumer 为什么不是同一种历史可见面。
