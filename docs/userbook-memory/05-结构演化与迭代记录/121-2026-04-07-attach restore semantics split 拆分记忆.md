# attach restore semantics split 拆分记忆

## 本轮继续深入的核心判断

120 已经把 init 厚度拆成：

- full payload
- bridge redacted payload
- internal hidden field
- model-only banner

但如果继续往下不补 attach 恢复这一页，读者又会把：

- history latest page 里的 init/banner
- live raw init 的 `onInit(...)`
- `handleRemoteInit(...)`

重新压成一句“attach 时初始化被恢复了”。

这轮要补的更窄一句是：

- history 路径恢复的是 transcript banner
- live raw init 恢复的是 slash/bootstrap side effect

都与 attach 后的初始化痕迹有关，但不是同一种 attach 恢复语义。

## 为什么这轮必须单列

如果不单列，正文最容易在三种错误里摇摆：

- 把 init banner 写成初始化 side effect
- 把 history hook 默认成也会触发 `onInit`
- 把 banner 重复写成 bootstrap callback 重复

这三种都会把：

- transcript restore
- raw init callback
- command-surface restore

重新压平。

## 本轮最关键的新判断

### 判断一：`pageToMessages(...)` 只恢复 transcript，不恢复 bootstrap

这是这页最需要钉死的根句。

### 判断二：`onInit(slash_commands)` 发生在 live raw init 上，不依赖 transcript banner

所以看见 banner 不等于恢复了 command surface。

### 判断三：两条 hook 都共用 `setMessages`，但只有 live hook 接了 `onInit`

这正是两种恢复语义分离的硬证据。

## 苏格拉底式自审

### 问：为什么这页不能并回 120？

答：120 讲 init thickness；121 讲 attach restore side effect，主语已经换了。

### 问：为什么这页不能并回 118？

答：118 讲 replay dedup；121 讲恢复了什么，不是去重了什么。

### 问：为什么一定要把 REPL 里的 hook wiring 拉进来？

答：因为没有 `useRemoteSession({ onInit: handleRemoteInit })` 这条证据，就容易把 history/live 两条路径写成同一种恢复。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/121-useAssistantHistory、fetchLatestEvents(anchor_to_latest)、pageToMessages、useRemoteSession onInit 与 handleRemoteInit：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义.md`
- `bluebook/userbook/03-参考索引/02-能力边界/110-history init banner replay 与 live slash restore 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/121-2026-04-07-attach restore semantics split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 121
- 索引层只补 110
- 记忆层只补 121

不新增目录，只更新导航。

## 下一轮候选

1. 单独拆 remote session 的 timeout/reconnect warning、`setConnStatus('reconnecting')` 与 loading false 为什么不是同一种 recovery lifecycle。
2. 单独拆 bridge-safe commands 过滤、tools/mcp/plugins redaction 与 transcript banner 为什么不是同一种移动端能力面裁剪。
3. 单独拆 attach 时 latest history page、live overlap 与 init/bootstrap callback 为什么不是同一种来源重放。
