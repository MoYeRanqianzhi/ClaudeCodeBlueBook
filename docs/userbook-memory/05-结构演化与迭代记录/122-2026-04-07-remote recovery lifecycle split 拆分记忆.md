# remote recovery lifecycle split 拆分记忆

## 本轮继续深入的核心判断

121 已经把 attach 后的 init 痕迹拆成：

- transcript banner replay
- live slash/bootstrap restore

但如果继续往下不补 recovery 这一页，读者又会把：

- timeout
- warning
- reconnecting
- disconnected

重新压成一句“远端在自动重连”。

这轮要补的更窄一句是：

- watchdog 是一层
- warning 是一层
- reconnect action / reconnecting state 是一层
- disconnected terminal release 又是下一层

都与恢复有关，但不是同一种 recovery lifecycle。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 warning 写成状态本体
- 把 reconnecting 写成最终断开
- 把 viewerOnly 也写进同样的 watchdog/recovery 流程

这三种都会把：

- liveness detection
- remediation prompt
- recovery action
- terminal release

重新压平。

## 本轮最关键的新判断

### 判断一：timeout watchdog 不是 disconnect detector

它只是在看“可能卡住了没有”。

### 判断二：warning / reconnect / reconnecting 不是同一步

它们分别属于 prompt、action、state projection。

### 判断三：viewerOnly 的 skip timeout 说明 recovery lifecycle 依赖宿主条件

不是所有 remote session 统一同构。

## 苏格拉底式自审

### 问：为什么这页不能并回 119？

答：119 讲 loading lifecycle；122 讲 transport health recovery，主语已经换了。

### 问：为什么这页不能并回 121？

答：121 讲 attach restore；122 讲 recovery after stall/gap/disconnect，问题域不同。

### 问：为什么一定要把 `clearTimeout` 在 echo filter 前执行这句注释拉进来？

答：因为没有它，timeout watchdog 的 heartbeat 语义就会写虚。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`
- `bluebook/userbook/03-参考索引/02-能力边界/111-watchdog、warning、reconnecting 与 disconnected 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/122-2026-04-07-remote recovery lifecycle split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 122
- 索引层只补 111
- 记忆层只补 122

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 bridge-safe commands 过滤、tools/mcp/plugins redaction 与 transcript banner 为什么不是同一种移动端能力面裁剪。
2. 单独拆 attach 时 latest history page、live overlap 与 init/bootstrap callback 为什么不是同一种来源重放。
3. 单独拆 non-viewerOnly timeout watchdog 与 viewerOnly skip-timeout 为什么不是同一种 remote liveness contract。
