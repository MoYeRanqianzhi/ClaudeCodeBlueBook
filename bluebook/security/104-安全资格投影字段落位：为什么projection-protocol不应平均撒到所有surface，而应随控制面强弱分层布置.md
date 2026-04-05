# 安全资格投影字段落位：为什么projection-protocol不应平均撒到所有surface，而应随控制面强弱分层布置

## 1. 为什么在 `103` 之后还必须继续写“字段落位”

`103-安全资格显式投影协议字段` 已经回答了：

`下一代统一安全控制台应把 projection_scope、hidden_truth_hint、handoff_route 等做成结构化字段。`

但如果继续往下追问，  
还会碰到一个更具体的问题：

`这些字段既然已经被定义出来，它们到底该摆在哪些 surface 上？`

如果答案是：

`每个 surface 都尽量多显示一点`

那协议仍然不会真正成熟。  
因为这会立刻带来两个后果：

1. 窄 surface 被信息淹没，变得既不清楚也不诚实
2. 强 surface 与弱 surface 失去层级差异，重新退化成“到处都像完整控制台”

所以 `103` 之后必须继续补出的下一层就是：

`安全资格投影字段落位`

也就是：

`projection protocol 不应平均撒到所有 surface，而应随控制面强弱、解释责任和可用空间分层布置。`

## 2. 最短结论

从源码看，Claude Code 当前各 surface 已经天然表现出不同的信息密度：

1. BridgeDialog 已承载 `statusLabel/statusColor/context/error/environment(verbose)` 等更高密度信息  
   `src/components/BridgeDialog.tsx:183-240`
2. PromptInputFooter 只显示 `status.label` 加一个 `Enter to view` affordance，明显是极窄 operational pill  
   `src/components/PromptInput/PromptInputFooter.tsx:182-189`
3. `/status` 只放 counts by state + `/mcp` hint，明显是 summary lane  
   `src/utils/status.tsx:89-114`
4. notifications 只放问题摘要 + route hint，明显是 interruptive repair lane  
   `src/hooks/notifs/useMcpConnectivityStatus.tsx:36-63`

所以这一章的最短结论是：

`字段协议必须按 surface 的责任和带宽分层落位，而不是平均分发。`

再压成一句：

`不是所有真相都该在所有地方出现。`

## 3. 现有源码已经自然长出了四种不同的落位层

## 3.1 authoritative detail surface

BridgeDialog 已经接近这类。

`src/components/BridgeDialog.tsx:183-240` 说明它至少会放：

1. `statusLabel`
2. `statusColor`
3. `contextSuffix`
4. `error`
5. verbose 下的 `environmentId`

这表明它具备承担下列字段的空间与责任：

1. `projection_scope`
2. `visible_truth_subset`
3. `hidden_truth_hint`
4. `handoff_route`
5. 更强的 debug / signer / id fields

也就是说，Dialog 这类面板最适合承接：

`完整投影元信息`

## 3.2 narrow operational pill

`src/components/PromptInput/PromptInputFooter.tsx:182-189` 则反过来表明：

1. 只显示 `status.label`
2. 只有被选中时才显示 `Enter to view`
3. implicit remote 下还会进一步压缩到只显示 reconnecting

这说明 footer pill 明显不适合塞进：

1. 长段 `hidden_truth_hint`
2. 多字段 truth subset
3. 复杂的 forbidden inference 说明

它最适合承接的只有：

1. 极短 `projection_scope` 暗示
2. 最短 `label`
3. 一个 `handoff affordance`

也就是说，footer 是：

`只负责把用户引向更强 surface，而不负责替更强 surface 解释。`

## 3.3 aggregate summary surface

`src/utils/status.tsx:89-114` 说明 `/status` 当前做的是：

1. counts by state
2. `/mcp` hint

这说明 summary 面最适合放置的是：

1. `projection_scope = aggregate_summary`
2. 聚合过的 `visible_truth_subset`
3. `hidden_truth_hint = server_detail_hidden`
4. `handoff_route`

而不适合放：

1. 单对象级别 detail
2. 长篇 failure explanation
3. 强 signer metadata

## 3.4 interruptive notification surface

`src/hooks/notifs/useMcpConnectivityStatus.tsx:36-63` 说明通知层当前做的是：

1. 问题摘要
2. 路由提示 `/mcp`
3. 中高优先级抢占

这说明 notification 面最适合放：

1. `projection_scope = notification_only`
2. 最短问题 truth
3. 最短 `handoff_route`
4. 一个极短 `hidden_truth_hint`

而不适合放：

1. 全部 completion 细节
2. 多层状态比较
3. 太多 contextual metadata

所以从现有代码看，  
不同 surface 的“带宽预算”其实已经很清楚了。

## 4. 从第一性原理看，字段落位至少应遵守三条规则

## 4.1 解释责任越强，字段越完整

也就是说：

1. Dialog / detailed control
   可承载完整 projection metadata
2. Summary
   只承载聚合字段与 handoff
3. Notification
   只承载 repair-needed truth + route
4. Footer pill
   只承载最小标签与进入更强面的入口

这条规则的本质是：

`字段密度应随解释责任单调增加。`

## 4.2 带宽越窄，越不应承载需要句法解释的字段

例如：

1. `hidden_truth_hint`
2. `forbidden_inference`
3. `visible_truth_subset`
   如果过长

这些字段都不该直接塞进 footer pill。

否则就会把窄 surface 从：

`即时导航元件`

变成：

`半残废的说明书`

## 4.3 handoff route 应在所有弱 surface 保持可见，但 full truth metadata 不必处处可见

这是最重要的一条。

弱 surface 虽然不配说全，  
但它必须配说：

`如果你要看全，去哪里。`

所以：

1. `handoff_route`
   应广泛存在
2. `projection_scope`
   至少应轻量存在
3. `hidden_truth_hint`
   应在 summary / notification / dialog 可见
4. `visible_truth_subset`
   应主要在较强 surface 完整出现

## 5. 下一代统一安全控制台最合理的落位方案

综合现有代码，我建议把 projection fields 分成四层：

## 5.1 Truth Layer

落在状态层 / view model，不直接展示。

字段例如：

1. `truth_bundle_id`
2. `completion_signer`
3. `signer_strength`
4. `raw_truth_inputs`

当前可从 AppState 与子系统结果中派生。  
用户无需直接看它，但 UI 需要它。

## 5.2 Projection Layer

直接服务于 control plane view model。

字段例如：

1. `projection_scope`
2. `visible_truth_subset`
3. `hidden_truth_hint`
4. `overclaim_ceiling`
5. `forbidden_inference`
6. `handoff_route`

这一层是本章主张新增的核心协议层。

## 5.3 Surface-Specific Layer

用于不同面板的裁剪。

1. Dialog
   全字段可见
2. Summary
   只保留聚合 truth + hidden hint + handoff
3. Notification
   只保留问题 truth + handoff + 极短 hint
4. Footer pill
   只保留 label + handoff affordance

## 5.4 Disclosure Layer

把 projection difference 翻译成人能理解的话。

例如：

1. `Summary only`
2. `Failures shown in notifications`
3. `Detailed control in /mcp`
4. `Press Enter to view more`

这层不是新增真相，  
而是把 projection fields 变成人类可消费文本。

## 6. 为什么“平均分发字段”是一条错误设计路线

如果把 projection fields 平均分发给所有 surface，  
会立刻产生四种问题：

1. footer 太重
   最小操作控件被说明文污染
2. notification 太长
   抢占型 surface 失去可扫读性
3. summary 太满
   聚合面冒充 detailed plane
4. detail 面反而不突出
   强 surface 与弱 surface 的差异被抹平

这说明落位设计不是排版问题，  
而是：

`安全解释权的空间化分配。`

## 7. 技术先进性：Claude Code 已经有“分层带宽感”，只差把它显式 schema 化

这一章最值得强调的技术判断是：

`Claude Code 现有实现已经隐含地尊重了 surface bandwidth，只是尚未把这套带宽分层升格为统一 schema。`

例如：

1. footer 只保留最小标签
2. notification 只保留问题与路由
3. `/status` 只保留 counts
4. Dialog 才承载更完整上下文

这说明团队不是没有意识到落位问题，  
而是已经做了很多正确的隐式选择。

下一步最合理的工程化升级，  
不是推翻现有 surface，  
而是把这些隐式选择写成：

`field placement protocol`

## 8. 哲学本质：不是所有界面都该追求“信息平等”，而应追求“责任对等”

这一章最重要的哲学结论是：

`界面之间不应追求信息平等，而应追求责任对等。`

也就是说：

1. 哪个界面承担的解释责任更强
2. 哪个界面就该拿更多字段
3. 哪个界面只是入口
4. 它就只该拿最低必要字段

这和民主式“大家都分一点信息”完全不同。  
安全控制面的哲学不是平均主义，  
而是：

`按责任分配可见真相。`

## 9. 苏格拉底式自我反思

可以继续问六个问题：

1. Footer 是否应该增加一个极轻量的 `scope` 标记，还是只保留 Enter affordance 就够？
2. Notification 是否应该永远附带 `handoff_route`，避免成为悬空警报？
3. `/status` 是否应显式显示 `summary only` 字样，还是只靠 `/mcp` hint 足够？
4. Dialog 是否应显式显示 `hidden_truth_hint`，说明它仍不是底层 raw truth 本体？
5. 不同 projection field 到底该落在 AppState、view model 还是纯渲染层，哪一层最稳？
6. 下一代统一安全控制台是否该在卡片级别而不是页面级别承载 projection metadata？

这些问题说明：

Claude Code 的下一代机会已经很明确：  
不是再加更多字段，  
而是把字段放对地方。


## 11. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 不要把 projection fields 平均撒给所有 surface
2. 强 control surface 承担完整 projection metadata，弱 surface 承担最小导航元信息
3. `handoff_route` 应比 `hidden_truth_hint` 更广泛地下沉到弱 surface
4. 聚合面最应展示的是 summary + handoff，而不是 detail
5. 通知面最应展示的是问题 + route，而不是全量真相
6. 统一控制台若不治理字段落位，协议再好也会在 UI 层失真

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，字段是否存在只解决了一半问题，另一半在于它们是否被放到了配得上它们的界面层级上。`
