# 如何把统一定价治理落成控制面实现：governance key、externalized truth chain、typed ask 与 continuation pricing

统一定价治理真正收费的，不是按钮、弹窗或 token 条，而是模型可达世界的扩张。更稳的实现顺序是：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `rollback / durable-transient cleanup`

其中：

- `authority source` 是 `governance key` 的 source slot。
- `Context Usage` 与 `pending action` 是 `decision window` 的证据面。
- `continuation gate` 是 `continuation pricing` 的 verdict。
- `rollback object` 是 cleanup / handoff 的 carrier。

如果把治理控制面 builder 前门继续压成最短公式，也只剩四句：

1. `same-world test`
   - 当前治理对象是否仍是一条单一控制面判断链
2. `externalized truth chain`
   - host 不自己反推，先消费正式外化节点
3. `decision window`
   - `Context Usage + pending action + worker state`
4. `continuation pricing + rollback object`
   - 继续资格和回退边界都按正式对象结算

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

## 1. 第一性原理：先给扩张定价，再谈拦截与节流

更成熟的治理实现，不是：

- 先把世界暴露给模型，再补几层审批与 stop 逻辑。

而是：

1. 先决定谁配改变边界。
2. 先决定哪些当前真相必须被外化。
3. 先决定 ask / allow / deny 围绕哪个正式对象交易。
4. 先决定当前窗口里哪些席位和成本正在被占用。
5. 先决定继续还有没有决策增益。
6. 先决定失败后哪些资产保留，哪些权威必须清除。

所以更准确的说法不是“安全系统 + 省 token 系统”，而是“围绕同一个 `governance key` 的扩张定价控制面”。

这页的 first reject signal 也只该先剩三条：

1. `Context Usage` 被独立做成仪表盘
2. `pending action` 只剩 UI 附件
3. `rollback object` 被退回文件回滚或重试次数

## 2. 第一步：先固定 `governance key`

Claude Code 真正先固定的不是 modal，而是 mode、settings、policy、host sync 与 session metadata 怎样汇合成同一个治理主键。

更稳的 builder 顺序是：

1. 先区分 provenance 与真正生效的治理主键。
2. 先给所有 mode / policy 变更定义唯一 choke point。
3. 先决定宿主、SDK 与 headless 路径只消费哪些正式权威状态。
4. 先明确哪些 source 只能自我收缩，不能自我扩权。

这一步里最重要的判断是：

- `authority source` 不再独立成根对象；它只是 `governance key` 的 source slot。

不要做的事：

1. 不要让 host、CLI、bridge 各自宣布 mode。
2. 不要把磁盘 settings 直接当成 effective governance truth。
3. 不要让 pending action 只活在某个展示通道里。
4. 不要把 source 只当 provenance 标签，而不让它决定谁配改边界。

## 3. 第二步：把外化真相写成 `externalized truth chain`

更成熟的治理控制面，不会让 host 自己从 UI、mode 名字、token 条和日志片段拼当前世界。它会先外化同一条真相链：

1. winner source 与 effective settings
2. visible capability set
3. pending action 与 worker state
4. context usage 与继续阈值
5. cleanup / rewind 所需的最小回退线索

实现动作：

1. 先让 `settings.sources / effective / applied`、`permission_mode`、`pending_action`、`worker_status` 与 usage 投影进入同一条外化链。
2. 先区分 authority truth、window truth 与 execution truth，不让它们在宿主侧重新混写。
3. 先把可见集写成主键的下游结果，而不是独立开关。
4. 先规定哪些 truth 面必须能跨 UI、SDK 与 headless 一致消费。

不要做的事：

1. 不要让 mode 名称代替治理主键。
2. 不要让 token 面板代替当前真相链。
3. 不要让 pending action 只被当成 UI 附件。
4. 不要让 host 靠本地推断补完当前世界。

## 4. 第三步：把动作审批写成 `typed ask`

Claude Code 真正保护的不是审批弹窗，而是正式 ask transaction：

1. 谁发起 ask。
2. ask 围绕哪个对象。
3. ask 由谁裁定。
4. ask 如何去重、撤销、过期与拒收。

更稳的实现顺序是：

1. 先定义 `request_id + tool_use_id` 这类事务关联键。
2. 先定义 `allow / ask / deny` 与 reason。
3. 先处理 duplicate response、orphan response 与 cancel path。
4. 再把结果投影给 UI、SDK 与 host。

不要做的事：

1. 不要把“弹窗出现过”当 ask 已成立。
2. 不要让 classifier 成为兜底万能阀。
3. 不要在没有 typed ask 的情况下直接拼展示文案。

## 5. 第四步：把 `decision window` 写成解释窗口

真正成熟的 `decision window` 不只解释还剩多少 token，而是解释：

1. 当前哪些 section、tools、memory、agents 在占席位。
2. 当前哪些对象尚未加载。
3. 当前 pending action 与 visible set 为什么成立。
4. 当前继续是否仍有决策增益。

因此：

- `Context Usage` 是窗口证据。
- `pending action` 是窗口证据。
- `worker_status` 与 state snapshot 也是窗口证据。

实现动作：

1. 先把 Context Usage、pending action、worker state 与 visible set 并排消费。
2. 先定义哪些变化会触发治理动作。
3. 先把“为什么贵”解释到 section、tool、memory、continuation。
4. 先确保任何 compact / continue 都能回钉到同一个 decision window。

不要做的事：

1. 不要把 Context Usage 做成独立仪表盘。
2. 不要把 token 百分比误当 decision window 本身。
3. 不要在没有窗口解释的情况下直接 compact 或继续。

## 6. 第五步：把继续资格写成 `continuation pricing`

Claude Code 把 continuation 理解成正式时间资产，而不是默认免费延长。

更稳的实现顺序是：

1. 先定义 continuation counter、delta 与 diminishing returns 条件。
2. 先定义 stop、continue、upgrade object 这三类 verdict。
3. 先把 pending action、headless deny 与 object upgrade 纳入同一判断链。
4. 先区分 durable assets 与 transient authority，避免 resume 免费续租旧权威。

因此：

- `continuation gate` 不是根对象，它只是 `continuation pricing` 的一个 verdict。

不要做的事：

1. 不要把 continue 理解成“再来一轮看看”。
2. 不要只看 token 剩余量，不看决策增益。
3. 不要让 headless 路径在无审批条件下继续免费运行。
4. 不要把旧 mode、旧 grant、旧 visible set 整包续租进 resume。

## 7. 第六步：把失败回退写成 `rollback / durable-transient cleanup`

治理成熟与否，关键看失败时是不是还能围绕同一个对象回退。

实现动作：

1. 先为每条治理路径定义 rollback carrier。
2. 先把需要保留的 durable assets 与必须清掉的 transient authority 分开。
3. 先把 next action、rewind 与 handoff ref 写回正式对象。
4. 先把文件回退、重试次数与 UI 提示降为执行投影，不让它们冒充治理语义。

不要做的事：

1. 不要失败后只谈回退文件或重试次数。
2. 不要把 rewind、cancel、resume 当成治理对象本身。
3. 不要让交接包只剩状态摘要，不剩 cleanup 语义。

## 8. 六步最小实现顺序

如果要把上面的原则压成一张 builder 卡，顺序应固定成：

1. `governance key`
2. `externalized truth chain`
3. `typed ask`
4. `decision window`
5. `continuation pricing`
6. `rollback / durable-transient cleanup`

## 9. 苏格拉底式检查清单

在你准备继续补一层安全或压缩机制前，先问自己：

1. 我固定的是 `governance key`，还是只固定了界面形式。
2. 当前 ask 是否已经是 typed transaction，而不是交互事件。
3. `Context Usage` 与 `pending action` 是否真的在解释 `decision window`。
4. continuation 是正式 pricing verdict，还是默认继续。
5. 失败时我能否立刻说出哪些资产保留、哪些权威清掉。

## 10. 一句话总结

真正成熟的统一定价治理，实现上不是多几条规则，而是把 `governance key`、`externalized truth chain`、`typed ask`、`decision window`、`continuation pricing` 与 `rollback / durable-transient cleanup` 写成同一条控制面判断链。
