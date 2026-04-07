# transport recovery action-state split 拆分记忆

## 本轮继续深入的核心判断

124 已经把 recovery signer 拆成：

- prompt
- authority projection
- action edge
- UI projection
- absence semantics

但如果继续往下不补 transport 这一页，读者还是会把：

- `handleClose(...)`
- `scheduleReconnect(...)`
- `reconnect()`
- `onReconnecting`
- `onClose`

重新压成一句：

- “底层就是一条 reconnecting 状态机。”

这轮要补的更窄一句是：

- close-driven backoff
- force reconnect
- terminal close projection

不是同一种 action-state contract。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `reconnect()` 写成 `onReconnecting()`
- 把所有 close 都写成 reconnecting 前奏
- 把 timeout warning 后的 UI 变化写成必然

这三种都会把：

- transport authority machine
- shared state projection
- gray implementation path

重新压平。

## 本轮最关键的新判断

### 判断一：`scheduleReconnect(...)` 才是 `onReconnecting()` 的 authority path

它不是所有 reconnect action 的通用出口。

### 判断二：`reconnect()` 是 force reconnect action，不是 backoff path 的别名

当前实现下它不天然穿过 `onReconnecting()`。

### 判断三：`onClose` / `onDisconnected` 是 terminal projection，不是 raw close event 的直译

只有不再 reconnect 的 path 才会落到这里。

### 判断四：timeout warning 后 UI 是否进入 `Reconnecting…` 属于当前实现灰度，不宜写成稳定承诺

## 苏格拉底式自审

### 问：为什么这页不能并回 122？

答：122 讲 recovery lifecycle 语义层；125 讲 transport authority machine。

### 问：为什么这页不能并回 124？

答：124 讲 signer ceiling；125 讲 authority path 内部分叉。

### 问：为什么一定要把 `close()` 先写进来？

答：因为 force reconnect 当前正是先把状态打成 `closed`，这会改变后续 close event 的含义。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/125-handleClose、scheduleReconnect、reconnect()、onReconnecting 与 onClose：为什么 transport recovery action-state contract 不是同一种状态.md`
- `bluebook/userbook/03-参考索引/02-能力边界/114-handleClose、scheduleReconnect、force reconnect、onReconnecting 与 onClose 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/125-2026-04-07-transport recovery action-state split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 125
- 索引层只补 114
- 记忆层只补 125

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `remoteSessionUrl`、brief 行、bridge pill、bridge dialog 与 attached viewer 为什么不是同一种 surface presence。
2. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief 行为什么不是同一种 remote status table。
3. 单独拆 `4001` retry budget、普通 reconnect budget 与 permanent close code 为什么不是同一种 terminality policy。
