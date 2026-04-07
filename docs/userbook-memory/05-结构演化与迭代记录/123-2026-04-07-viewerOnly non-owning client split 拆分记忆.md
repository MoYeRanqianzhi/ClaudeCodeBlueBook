# `viewerOnly` non-owning client split 拆分记忆

## 本轮继续深入的核心判断

118 已经把 viewerOnly 一侧的 replay dedup 拆成：

- local echo filter
- history/live overlap
- source-blind transcript sink

122 又把 owner-side recovery 拆成：

- watchdog
- warning
- reconnecting
- disconnected

但如果继续往下不补这一页，读者还是会把 `viewerOnly` 压成一句：

- “就是个更弱的 remote viewer，顺手关掉几项能力。”

这轮要补的更窄一句是：

- `viewerOnly` 仍然能 send prompt
- 但它不拥有 history / title / timeout / interrupt 这组 session-control 主权

所以更稳的概念不是：

- read-only viewer

而是：

- non-owning interactive client

## 为什么这轮必须单列

如果不单列，正文最容易在三种误判里摇摆：

- 把 `viewerOnly` 写成完全不能交互
- 把能发 prompt 直接推成也拥有 session owner 权
- 把 history、timeout、`Ctrl+C`、title 写成四个互不相干的 viewer 特判

这三种都会把：

- content plane
- history ledger
- session metadata
- session control

重新压平。

## 本轮最关键的新判断

### 判断一：`viewerOnly` 是入口合同，不是 adapter 尾端小补丁

它在 `main.tsx` 的 assistant 入口就被创建，而不是后面临时加的一层显示选项。

### 判断二：`viewerOnly` 不是 no-input，而是 no-ownership

REPL 仍然会让它走 `activeRemote.sendMessage(...)`。

### 判断三：skip history / title / timeout / interrupt 本质都指向 session owner 边界

它们不该被写成松散的四个 viewer 特判。

### 判断四：skip timeout 不等于完全没有 reconnect

更准确地说，被切掉的是 owner-side watchdog repair，而不是 shared transport reconnect。

## 苏格拉底式自审

### 问：为什么这页不能并回 118？

答：118 讲 replay dedup；123 讲 ownership contract，主语已经换了。

### 问：为什么这页不能并回 122？

答：122 讲 owner-side recovery lifecycle 内部分层；123 讲哪些 client 一开始就不进入同一条 owner contract。

### 问：会不会把 `pure viewer` 注释顶翻了？

答：不会。这页没有否认注释，而是根据提交链和控制链补了一句更稳的行为解释：

- pure viewer 更接近 non-owning client，而不等于完全 no-input

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/123-viewerOnly、history、timeout、Ctrl+C 与 title：为什么 assistant client 不是 session owner.md`
- `bluebook/userbook/03-参考索引/02-能力边界/112-viewerOnly、history、timeout、Ctrl+C 与 title 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/123-2026-04-07-viewerOnly non-owning client split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 123
- 索引层只补 112
- 记忆层只补 123

不再扩新目录。

## 下一轮候选

1. 单独拆 transcript warning、`remoteConnectionStatus`、force reconnect、Spinner/BriefIdleStatus 与 attached viewer 为什么不是同一种 recovery signer。
2. 单独拆 assistant 入口里的 `isBriefOnly`、remote-safe commands、history gate 与 viewerOnly 为什么不是同一种 entry contract。
3. 单独拆 `viewerOnly` 仍可 send prompt、但 local-jsx slash command 继续本地落地，为什么不是同一种 command ownership。
