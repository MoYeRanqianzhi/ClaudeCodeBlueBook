# loading lifecycle split 拆分记忆

## 本轮继续深入的核心判断

118 已经把 replay dedup 拆成：

- visibility
- echo filter
- overlap reconciliation
- source-blind sink

但如果不继续往下补 loading 这一页，读者又会把：

- `sendMessage -> true`
- `onPermissionRequest -> false`
- `onAllow -> true`
- `result/cancel/disconnect -> false`

重新压成一句“loading 只是从 true 变回 false”。

这轮要补的更窄一句是：

- `true` 至少分成 start / resume
- `false` 至少分成 pause / turn-end / abort / teardown

都作用在同一个 flag 上，但不是同一种 loading lifecycle。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `onAllow(true)` 写成新的 request start
- 把 permission request 的 false 写成完成
- 把 disconnect false 写成普通 turn close

这三种都会把：

- request start
- approval pause/resume
- turn-end release
- abort / teardown

重新压平。

## 本轮最关键的新判断

### 判断一：`sendMessage(true)` 和 `onAllow(true)` 不是同一种 true

一个是 start，一个是 resume。

### 判断二：`onPermissionRequest(false)` 和 `result(false)` 不是同一种 false

一个是 pause，一个是 turn-end。

### 判断三：`cancel/disconnect(false)` 又和上面两者不同

它们属于 abort / teardown，不是 completion。

## 苏格拉底式自审

### 问：为什么这页不能并回 116？

答：116 讲 completion signal 跨层拆分；119 讲 loading flag 自身的 edge semantics，再往内压了一层。

### 问：为什么这页不能并回 118？

答：118 讲 replay 来源与 dedup；119 讲 execution waiting state，主语已经换了。

### 问：为什么一定要把 SSH 拉进来？

答：因为没有 sibling host 的镜像证据，太容易把 direct connect 当成偶发写法。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/119-sendMessage、onPermissionRequest、onAllow、result、cancelRequest 与 onDisconnected：为什么 direct connect 的 setIsLoading(true_false) 不是同一种 loading lifecycle.md`
- `bluebook/userbook/03-参考索引/02-能力边界/108-loading start、pause、resume、turn-end 与 teardown 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/119-2026-04-07-loading lifecycle split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 119
- 索引层只补 108
- 记忆层只补 119

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 bridge redacted init、QueryEngine full init 与 transcript init prompt 为什么不是同一种 init payload thickness。
2. 单独拆 history replay 里的 init/banner 与 live `onInit(...)` 为什么不是同一种 attach 恢复语义。
3. 单独拆 remote session 的 timeout/reconnect warning、`setConnStatus('reconnecting')` 与 loading false 为什么不是同一种 recovery lifecycle。
