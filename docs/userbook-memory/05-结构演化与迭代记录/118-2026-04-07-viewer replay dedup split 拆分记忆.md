# viewer replay dedup split 拆分记忆

## 本轮继续深入的核心判断

117 已经把 init visibility 拆成：

- metadata
- callback
- dedupe
- transcript prompt
- bootstrap

但继续往下不补 replay 这一页，读者又会把：

- `convertUserTextMessages`
- `sentUUIDsRef`
- latest history page
- live append

重新压成一句“viewer 会自动去重重放”。

这轮要补的更窄一句是：

- visibility policy 是一层
- local echo dedup 是一层
- history-vs-live overlap dedup 是一层
- source-blind transcript sink 又是下一层

都与 replay 重复有关，但不是同一种 replay dedup。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `convertUserTextMessages` 写成 dedup 开关
- 把 `sentUUIDsRef` 写成跨来源通用索引
- 把 history/live overlap 写成 local echo 的另一种表现

这三种都会把：

- visibility
- echo filter
- overlap reconciliation
- sink behavior

重新压平。

## 本轮最关键的新判断

### 判断一：`convertUserTextMessages` 只是把 replayed user text 变成 `message`

不是 dedup 自身。

### 判断二：`sentUUIDsRef` 只服务本地 POST -> WS echo 这一条窄链路

因为只有 `sendMessage(..., { uuid })` 会往 ring 里播种。

### 判断三：history attach overlap 是另一类来源重叠

代码已经明说当前不会在 attach 时用 `sentUUIDsRef` 处理它。

## 苏格拉底式自审

### 问：为什么这页不能并回 117？

答：117 讲 init visibility；118 讲 replay sources 和 dedup surfaces，主语已经变了。

### 问：为什么这页不能并回 115？

答：115 讲 adapter 内 policy；118 的主冲突跨到了 local-first、history-first 和 source-blind sink 三层来源关系。

### 问：为什么一定要把 `REPL.tsx` 里的本地 `createUserMessage(...)` 拉进来？

答：因为没有这条链路，`sentUUIDsRef` 的 local echo 语义就会写虚。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`
- `bluebook/userbook/03-参考索引/02-能力边界/107-viewerOnly local echo、history attach overlap 与 replay sink 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/118-2026-04-07-viewer replay dedup split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 118
- 索引层只补 107
- 记忆层只补 118

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 `sendMessage -> setIsLoading(true)`、`permission allow -> setIsLoading(true)`、`result/disconnect/cancel -> setIsLoading(false)` 为什么不是同一种 loading lifecycle。
2. 单独拆 bridge redacted init、QueryEngine full init 与 transcript init prompt 为什么不是同一种 init payload thickness。
3. 单独拆 history replay 里的 init/banner 与 live `onInit(...)` 为什么不是同一种 attach 恢复语义。
