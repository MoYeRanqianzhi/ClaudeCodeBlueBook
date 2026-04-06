# stream-json verbose raw wire 拆分记忆

## 本轮继续深入的核心判断

20 已经把 `stream-json` 从“普通 JSON 开关”里拆出来了。

105 又把 `post_turn_summary` 的 wider-wire visibility 单独拆出来了。

继续往下压时，最自然的新误判是：

- `stream-json --verbose` 既然持续吐消息，那它吐出的就是 ordinary `SDKMessage`

这轮要补的就是这个细缝：

- `stream-json --verbose` 更接近 wider raw stdout wire
- 而不是普通 core SDK message surface

## 为什么这轮必须单列

如果不单列，正文会自然回摆到两种过粗表述：

- `stream-json` 只是“更详细 JSON”
- `stream-json` 就是“把 public SDK message 原样流式打印”

这两种都没抓住真正的层级差异。

## 本轮最关键的新判断

### 判断一：`--verbose` 在这条路径里是协议闸门，不是装饰参数

这点值得单列，因为源码直接禁止 `stream-json` without `--verbose`。

### 判断二：`lastMessage` 过滤在这条路径里继续存在，但不再控制“写出什么”

这是从 terminal contract 走向 wire contract 的关键转折。

### 判断三：这页讲 output mode contract，不讲 family 目录学

必须持续克制，避免又掉回“哪些消息会不会出现在流里”的大列表。

## 苏格拉底式自审

### 问：为什么这页不能并回 20？

答：20 讲的是 entrypoint / mode；106 讲的是进入该 mode 后，消息层到底处在哪个 contract surface。

### 问：为什么这页不能并回 105？

答：105 是单对象 `post_turn_summary` 的可见性层级；106 是整个 output mode 的 raw wire contract。

### 问：为什么必须强调 `already logged above`？

答：因为这句正好把“逐条写出”与“终态收口”在控制流上明确分开。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/106-stream-json、verbose、StdoutMessageSchema、SDKMessageSchema 与 lastMessage：为什么 headless print 的 raw wire 输出不是普通 core SDK message surface.md`
- `bluebook/userbook/03-参考索引/02-能力边界/95-stream-json verbose raw wire 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/106-2026-04-06-stream-json verbose raw wire 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 106
- 索引层只补 95
- 记忆层只补 106

不把它并回 20，也不把它并回 105。

## 下一轮候选

1. 单独拆 `model` 为什么在 metadata restore 里属于 separate override，而不是 `externalMetadataToAppState(...)` 的对称逆映射。
2. 单独拆 direct connect 路径对 `post_turn_summary` 的过滤为什么属于 consumer path，而不是 summary existence contract。
3. 单独拆 `streamlined` transformer 为什么是在 raw wire 之前改写，而不是终态收口之后补充。
