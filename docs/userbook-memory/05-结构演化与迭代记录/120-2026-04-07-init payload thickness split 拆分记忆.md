# init payload thickness split 拆分记忆

## 本轮继续深入的核心判断

119 已经把 loading flag 拆成：

- start
- pause / resume
- turn-end
- abort / teardown

但如果继续往下不补 init 厚度这一页，读者又会把：

- QueryEngine 发的 init
- REPL bridge 发的 init
- transcript 里的 init banner

重新压成一句“同一个 init 只是多走了几条路”。

这轮要补的更窄一句是：

- full SDK payload 是一层
- bridge redacted payload 是一层
- internal hidden field 是一层
- transcript model-only banner 又是下一层

都与 init 有关，但不是同一种 payload thickness。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 bridge init 写成 full payload 副本
- 把 banner 写成 metadata 可见性
- 把 public schema 写成 init 的全部厚度

这三种都会把：

- builder contract
- host input redaction
- internal extra field
- transcript prompt collapse

重新压平。

## 本轮最关键的新判断

### 判断一：同一个 builder 不保证同一种厚度

因为宿主喂入的 inputs 可以不同。

### 判断二：bridge redaction 和 transcript banner 不是同一种“变薄”

一个仍是 object，一个已经是 prompt。

### 判断三：public schema 外还有 internal hidden thickness

这能保护稳定面和灰度面不要混写。

## 苏格拉底式自审

### 问：为什么这页不能并回 117？

答：117 讲 init visibility；120 讲 payload thickness，同一对象的主语已经变了。

### 问：为什么这页不能并回 119？

答：119 讲 loading lifecycle；120 讲 init metadata thickness，问题域完全不同。

### 问：为什么要把 `UDS_INBOX` 拉进来？

答：因为没有 internal hidden field 这条证据，就容易把 public schema 误写成全部厚度。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/120-buildSystemInitMessage、QueryEngine、useReplBridge、convertInitMessage 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness.md`
- `bluebook/userbook/03-参考索引/02-能力边界/109-init full payload、bridge redaction 与 model-only banner 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/120-2026-04-07-init payload thickness split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 120
- 索引层只补 109
- 记忆层只补 120

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 history replay 里的 init/banner 与 live `onInit(...)` 为什么不是同一种 attach 恢复语义。
2. 单独拆 remote session 的 timeout/reconnect warning、`setConnStatus('reconnecting')` 与 loading false 为什么不是同一种 recovery lifecycle。
3. 单独拆 bridge-safe commands 过滤、tools/mcp/plugins redaction 与 transcript banner 为什么不是同一种移动端能力面裁剪。
