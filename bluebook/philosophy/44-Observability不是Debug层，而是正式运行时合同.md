# Observability不是Debug层，而是正式运行时合同

这一章回答四个问题：

1. 为什么 Claude Code 的 observability 不该被理解成调试附属层。
2. 为什么真正成熟的 agent runtime 必须让自己可被解释。
3. 为什么输入真相、状态真相与稳定性真相共同构成可解释运行时。
4. 这对 agent 平台构建者意味着什么。

## 1. 先说结论

Claude Code 的 observability，真正被设计成的是：

- 正式运行时合同

它并不满足于：

- 系统内部知道发生了什么

而是要求：

- 人类知道模型看见了什么
- 宿主知道 worker 正处于什么状态
- 系统自己知道前缀为什么稳定或为什么失稳

所以 observability 在这里不是：

- debug layer

而是：

- explainability contract

## 2. 为什么成熟系统必须可被解释

一个多宿主、可恢复、可压缩、可分叉的 runtime，如果不能解释自己，最终会同时坏在三处：

1. 用户调不动它
2. 宿主接不稳它
3. 作者演化不清它

Claude Code 显然很清楚这一点。

所以它不断把运行时真相外化成：

- control schema
- external metadata
- cache break reason
- context suggestions

也就是说，它不愿让“为什么这样”只留在源码内部。

## 3. 为什么 “还剩多少 token” 远远不够

很多系统把 observability 等同于：

- 还剩多少窗口

Claude Code 的设计已经说明这不够。

因为真正的问题从来不只是：

- 还剩多少

而是：

- 花在哪
- 卡在哪
- 为什么变了

所以它才会进一步暴露：

- `systemPromptSections`
- `messageBreakdown`
- `pending_action`
- `worker_status`
- `cache break reason`

这些对象。

这说明 Claude Code 的 observability 本质上不是：

- 计量

而是：

- 解释

## 4. 可解释运行时由哪三层组成

更高一层看，Claude Code 已经在做三层 explainability。

### 4.1 输入真相

告诉你：

- 模型真正看见了什么

### 4.2 状态真相

告诉你：

- 现在在跑、空闲、还是等人操作

### 4.3 稳定性真相

告诉你：

- 前缀为什么命中
- 为什么失稳
- 失稳究竟是预期下降、配置变化，还是服务器侧失效

只有三层合起来，系统才真正可被解释。

## 5. 为什么这条线和 prompt 魔力、安全、预算都连在一起

因为一个不能解释自己的系统，最终会同时在三条线上退化：

### 5.1 prompt 线

你不知道前缀为什么失稳，调优就会回到拍脑袋。

### 5.2 安全线

你不知道当前为什么 blocked、谁改了可见能力面，治理就会重新神秘化。

### 5.3 预算线

你不知道 token 花在哪、哪些对象在膨胀，预算器就会重新退回黑箱。

所以 observability 在 Claude Code 里不是周边层，而是：

- prompt
- 安全
- 预算

三条主线的共同解释层。

## 6. 苏格拉底式追问

### 6.1 如果 observability 只是调试接口，为什么还要把它写进正式 control schema

因为它显然不只是给开发者看的。

### 6.2 如果 `pending_action` 只是事件流附属字段，为什么还要镜像进 metadata 快照

因为当前状态不能只靠回放推理。

### 6.3 如果 cache break 只是性能问题，为什么还要追踪根因而不是只报 miss

因为真正要维护的是长期稳定性，而不是单次统计。

### 6.4 一个不能解释自己的 agent runtime，真的能长期演化吗

很难。
它迟早会回到“只能靠经验和运气调”。

## 7. 对 Agent 设计者的启发

如果想复制 Claude Code 的强点，最该学的不是：

- 多打一层日志

而是：

1. 让输入真相可查询。
2. 让状态真相可快照。
3. 让稳定性真相可归因。
4. 让这些解释面继续驱动下一步动作，而不是停留在展示层。

## 8. 一句话总结

Claude Code 的 observability 之所以高级，不在于它更会打点，而在于它把 explainability 本身做成了正式运行时合同。
