# init visibility split 拆分记忆

## 本轮继续深入的核心判断

116 已经把：

- visible result
- turn-end
- busy state

拆成 completion 三层。

但如果继续往下不补 init 这一页，读者又会把：

- `system.init` callback-visible
- `useDirectConnect` 去重
- `convertInitMessage(...)`
- `onInit(slash_commands)`

重新压成一句“初始化显示”。

这轮要补的更窄一句是：

- raw init metadata 是一层
- callback-visible init 是一层
- transcript init prompt 是一层
- slash bootstrap 是一层
- host-local dedupe 又是下一层

都与初始化可见性有关，但不是同一种 init visibility。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 dedupe 写成 init 本体只出现一次
- 把 `convertInitMessage(...)` 写成 full metadata projection
- 把 `onInit(slash_commands)` 写成 transcript 副作用

这三种都会把：

- metadata object
- host-local filtering
- transcript prompt
- capability bootstrap

重新压平。

## 本轮最关键的新判断

### 判断一：`system.init` 首先是 public SDK metadata object

不是普通提示文案。

### 判断二：`useDirectConnect` 去重回答的是 host-local duplicate suppression

不是 init contract 本身。

### 判断三：`convertInitMessage(...)` 和 `onInit(slash_commands)` 分别属于 transcript consumer 与 bootstrap consumer

它们消费的是同一个 raw object，但保留的厚度完全不同。

### 判断四：history replay 里的 init prompt 不等于 live init bootstrap 重放

`pageToMessages(...)` 会把 init 投进 transcript，

但当前没有证据表明它会重跑 live `onInit(...)`。

这条要留给下一页 replay/dedup 专题，不提前污染 117。

## 苏格拉底式自审

### 问：为什么这页不能并回 116？

答：116 讲 completion semantics；117 讲 initialization visibility，问题域已经换了。

### 问：为什么这页不能并回 115？

答：115 讲 adapter 内 policy；117 的主冲突已经跨到 builder、callback、dedupe、bootstrap 多层。

### 问：为什么要把 `useReplBridge` 拉进来？

答：因为没有 bridge gate/redaction 这条证据，就容易把 public init contract 写成所有宿主天然同宽。

### 问：为什么不把 `sentUUIDsRef` 和 history-vs-live overlap 一起写进正文？

答：因为那已经是 replay cross-source dedup 问题，不是 init visibility 本身；当前只把它记成下一轮候选。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/117-buildSystemInitMessage、SDKSystemMessage(init)、useDirectConnect 去重、convertInitMessage 与 onInit：为什么 callback-visible init、transcript init 提示与 slash bootstrap 不是同一种初始化可见性.md`
- `bluebook/userbook/03-参考索引/02-能力边界/106-system.init metadata、callback、dedupe 与 bootstrap 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/117-2026-04-07-init visibility split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 117
- 索引层只补 106
- 记忆层只补 117

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 viewerOnly 的 `convertUserTextMessages`、`sentUUIDsRef` echo dedup 与 history attach overlap 为什么不是同一种 replay 去重。
2. 单独拆 `sendMessage -> setIsLoading(true)`、`permission allow -> setIsLoading(true)`、`result/disconnect/cancel -> setIsLoading(false)` 为什么不是同一种 loading lifecycle。
3. 单独拆 bridge redacted init、QueryEngine full init 与 transcript init prompt 为什么不是同一种 init payload thickness。
