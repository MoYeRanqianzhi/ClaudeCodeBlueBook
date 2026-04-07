# print-remote recovery stage split 拆分记忆

## 本轮继续深入的核心判断

164 已经把恢复边界附近的 runtime stage 拆开了。

但正文还缺一个更细的 print remote 结论：

- remote hydrate、metadata 回填与 empty-session startup fallback 也不是同一种 recovery stage

本轮要补的更窄一句是：

- `print.ts` 的 remote resume 不是“把远端内容拉下来”这一层动作，而是 transcript hydrate、metadata refill、emptiness semantics 三层串接

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 metadata refill 写成 hydrate 的尾巴
- 把空 transcript startup fallback 写成 hydrate 失败
- 把 v1 ingress 和 CCR v2 internal events 写成同一种 remote source

这三种都会把：

- transcript
- metadata
- emptiness semantics

重新压扁。

## 本轮最关键的新判断

### 判断一：`hydrateFromCCRv2InternalEvents()` / `hydrateRemoteSession()` 先写 transcript，不等于恢复完成

### 判断二：`externalMetadataToAppState()` 与 `setMainLoopModelOverride()` 是单独的 metadata refill 层

### 判断三：空 transcript 在 remote 路径里讨论的是 emptiness semantics，不是单纯失败

### 判断四：CCR v2 和 ingress 的 remote source 不是同一种前置数据源

### 判断五：startup fallback 的输出是新 hook payload，不是旧会话 replay

## 苏格拉底式自审

### 问：为什么这页不是 163 的附录？

答：因为 163 只讲 print pre-stage 总链；165 继续把 remote 路径内部再拆细。

### 问：为什么一定要写 metadata refill？

答：因为这正是 remote 路径最容易被忽略的一层，如果不写，CCR v2 会被误画成纯 transcript hydrate。

### 问：为什么一定要写 startup fallback？

答：因为它直接决定空 remote transcript 最后落成“新 startup”还是“resume 失败”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/165-hydrateFromCCRv2InternalEvents、externalMetadataToAppState、hydrateRemoteSession 与 startup fallback：为什么 print resume 的 remote recovery 不是同一种 stage.md`
- `bluebook/userbook/03-参考索引/02-能力边界/154-hydrateFromCCRv2InternalEvents、externalMetadataToAppState、hydrateRemoteSession 与 startup fallback 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/165-2026-04-08-print-remote recovery stage split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 165
- 索引层只补 154
- 记忆层只补 165

不回写 162、163。

## 下一轮候选

1. 继续拆 interactive live `/resume` 与 startup direct resume 为什么共享 restore contract，却不是同一种 session-unwind stage。
2. 继续拆 CCR v2 remote metadata refill 与更宽的 observer metadata 消费为什么不是同一种状态回填面。
