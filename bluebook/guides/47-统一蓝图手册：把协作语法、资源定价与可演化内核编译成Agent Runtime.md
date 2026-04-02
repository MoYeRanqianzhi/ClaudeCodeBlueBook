# 统一蓝图手册：把协作语法、资源定价与可演化内核编译成Agent Runtime

这一章不再分别解释 Prompt、安全/省 token 与源码先进性，而是把三条线压成同一张 Agent Runtime 蓝图。

它主要回答五个问题：

1. 为什么 Claude Code 的真正先进性，来自三条母线共同成立，而不是某一个点子特别强。
2. 怎样把协作语法、资源定价与可演化内核编译成同一套设计蓝图。
3. 怎样用这张蓝图识别“看起来像 Claude Code，实际上只是模仿表面”的系统。
4. 怎样用苏格拉底式追问避免把蓝图退回三份并列专题。
5. 怎样把这张蓝图真正用于设计评审与危险改动面审查。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/tools.ts:271-367`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1280`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionStorage.ts:1085-1215`
- `claude-code-source-code/src/utils/task/framework.ts:160-269`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`

这些锚点共同说明：

- Claude Code 的高级感来自同一套设计单位被三个方向同时约束：模型消费的世界被编译、资源使用被定价、演化边界被预先塑形。

## 1. 第一性原理

更成熟的 Agent Runtime 蓝图，不是：

- 把 prompt、安全、结构三块分别做好

而是：

- 让这三块围绕同一套设计单位同时成立

这套设计单位至少包括：

1. 正式对象
2. authority surface
3. consumer subset
4. recovery asset
5. dangerous change surface

如果这五个单位没有统一，系统再像 Claude Code，也很容易只是：

- 模仿它的表面

## 2. 第一条母线：协作语法

协作语法真正回答的是：

- 模型到底在围绕什么世界行动

成熟做法是：

1. 先把世界编译成协议输入
2. 先把 stable prefix 与 dynamic boundary 分开
3. 先让 protocol transcript 替代 UI transcript
4. 先让 lawful forgetting 替代聊天压缩

危险改动面：

1. system prompt 结构
2. tool pool 排序与可见性
3. transcript normalization
4. compact boundary

## 3. 第二条母线：资源定价

资源定价真正回答的是：

- 哪些动作、能力、上下文席位与继续时间值得被支付

成熟做法是：

1. 先把 `deny/ask/allow` 写成 typed decision
2. 先把工具可见性写成 deferred / subset
3. 先把大结果写成 externalization / preview / ledger
4. 先把 continuation 写成 stop / continue / object upgrade

危险改动面：

1. permission 顺序
2. ToolSearch / deferred visibility
3. result replacement fate
4. budget 决策与 continuation 语义

## 4. 第三条母线：可演化内核

可演化内核真正回答的是：

- 在不断增长的情况下，系统怎样仍然保住正确的 authority、recovery 与维护边界

成熟做法是：

1. 先把共享规则压成 leaf module
2. 先把脏边关进 anti-cycle seam
3. 先把 session / task / bridge / recovery 写成对象级真相
4. 先把 internal-only / consumer subset / build surface 分层

危险改动面：

1. single-source file
2. registry / choke point
3. stale-state patch
4. bridge pointer / recovery asset

## 5. 统一蓝图

如果要把三条母线收成一张蓝图，可以压成这五步：

### 5.1 先定义对象

- request object
- governance object
- rollback object
- recovery object
- host truth object

### 5.2 再定义 authority

- 谁宣布这些对象当前的真相
- 谁只消费这些对象
- 谁不能自己生成第二套真相

### 5.3 再定义 pricing

- 哪些动作先协商
- 哪些能力先隐藏
- 哪些结果先外置
- 哪些继续必须升级对象

### 5.4 再定义 recovery

- 哪些资产必须 durable
- 哪些状态必须 stale-safe
- 哪些路径必须可 replay / resume

### 5.5 最后定义 surfaces

- commands surface
- tools surface
- host surface
- internal-only surface
- feature-gated surface

## 6. 怎么识别“像 Claude Code 但其实不是”

看到下面信号时，应提高警惕：

1. prompt 看起来很长，但没有协作语法编译器。
2. 安全规则很多，但没有统一资源定价秩序。
3. 目录很整齐，但没有 authority surface 与 recovery object。
4. 宿主能显示很多消息，但没有 control / snapshot / recovery 闭环。
5. 系统有很多 feature gate，但没有 consumer subset 边界说明。

## 7. 设计评审卡

```text
正式对象:
authority surface:
consumer subset:
pricing order:
recovery asset:
dangerous change surface:
这次设计最像哪类失真:
- 表面模仿 / 权威失焦 / 预算失序 / 恢复缺席 / 边界混写
下一步该补的是:
- object / authority / pricing / recovery / surface
```

## 8. 苏格拉底式检查清单

在你准备宣布“这就是我们的 Agent Runtime 蓝图”前，先问自己：

1. 模型消费的是协作语法，还是更多文本。
2. 资源被统一定价了，还是只是多了几条限制。
3. authority surface 和 consumer subset 是否分清。
4. 恢复资产是在保护对象，还是在补日志。
5. 这套蓝图是否能帮助后来者更快看见危险改动面。

## 9. 一句话总结

Claude Code 值得迁移的，不是某一个功能或某一段 prompt，而是把协作语法、资源定价与可演化内核编译成同一套 Agent Runtime 蓝图。
