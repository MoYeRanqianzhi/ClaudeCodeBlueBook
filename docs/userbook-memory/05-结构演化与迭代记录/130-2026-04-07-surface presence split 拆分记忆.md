# surface presence split 拆分记忆

## 本轮继续深入的核心判断

129 已经把 `WebSocketTransport` 的恢复主权拆出来了。

但如果继续往下不补这一页，读者还是会把：

- `remoteSessionUrl`
- brief line
- bridge pill
- bridge dialog
- attached viewer

重新压成一句：

- “这些只是不同位置的远端连接提示。”

这轮要补的更窄一句是：

- 这些不是同一种远端连接提示，而是五种不同的 surface presence

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 `remoteSessionUrl` 写成连接健康指示器
- 把 brief line 写成 remote URL / bridge URL 的另一种展示
- 把 bridge pill、bridge dialog 和 attached viewer transcript signer 写成同一层可见性

这三种都会把：

- URL presence
- runtime projection
- coarse summary
- inspect / disconnect
- transcript-signed attachment

重新压扁。

## 本轮最关键的新判断

### 判断一：`remoteSessionUrl` 只属于 `--remote` URL presence 链

### 判断二：brief line 是 brief-only idle 的 runtime projection，不是 URL 面

### 判断三：bridge pill 是 coarse summary，不是 existence proof

### 判断四：bridge dialog 是 inspect / disconnect surface，不是 pill 的展开态

### 判断五：attached viewer 的主 signer 是 transcript attach fact，不是 URL

## 苏格拉底式自审

### 问：为什么这页不能并回 25？

答：25 讲 control / config / status / disconnect 不是同一个按钮；130 讲几种 presence surface 不是同一种可见性。

### 问：为什么这页不能并回 26？

答：26 讲 locator split；130 讲 visibility split。

### 问：为什么一定要把 attached viewer 拉进来？

答：因为不把 attach transcript signer 单列，读者就会继续把 viewer 写成 `--remote` URL mode。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/130-remoteSessionUrl、brief line、bridge pill、bridge dialog 与 attached viewer：为什么它们不是同一种 surface presence.md`
- `bluebook/userbook/03-参考索引/02-能力边界/119-remoteSessionUrl、brief line、bridge pill、bridge dialog 与 attached viewer 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/130-2026-04-07-surface presence split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 130
- 索引层只补 119
- 记忆层只补 130

不扩目录，不回写旧页。

## 下一轮候选

1. 单独拆 `warning` transcript、`remoteConnectionStatus`、`remoteBackgroundTaskCount` 与 brief line，为什么 remote session 的四类可见信号分属四张账，而不是同一张 remote status table。
2. 单独拆 direct connect / remote session / bridge 之间 authoritative runtime state 到 transcript、footer、dialog、store 的消费断点，为什么 bridge 能形成三面对齐而另外两条线更多只是 event projection。
3. 如果后续还要继续往 presence 方向延伸，再把 bridge 的 `bridge_status` 常显 transcript 与 `--remote` 普通 `info` line 单独拆成一页。
