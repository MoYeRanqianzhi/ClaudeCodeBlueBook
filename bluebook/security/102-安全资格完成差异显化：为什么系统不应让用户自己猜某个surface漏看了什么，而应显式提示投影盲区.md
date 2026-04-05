# 安全资格完成差异显化：为什么系统不应让用户自己猜某个surface漏看了什么，而应显式提示投影盲区

## 1. 为什么在 `101` 之后还必须继续写“完成差异显化”

`101-安全资格完成投影` 已经回答了：

`completion 真相统一成立后，不同 surface 仍只能看到它的不同子集。`

但如果继续往下追问，  
还会遇到一个更产品化的问题：

`既然不同 surface 看到的是子集，系统是否应该把“这里没显示的并不代表不存在”显式告诉用户？`

如果答案是否定的，  
用户就只能自己猜：

1. footer 没显示 failed，是不是其实没失败
2. `/status` 只显示 count，是不是就没有单体细节
3. notification 只报问题，是不是其他维度都没问题
4. Dialog 看起来更全，是不是就真的看见了全部 completion truth

这就会把投影分层重新退化成认知陷阱。

所以 `101` 之后必须继续补出的下一层就是：

`安全资格完成差异显化`

也就是：

`系统不应让用户自己猜某个 surface 漏看了什么，而应显式提示该 surface 只投影了完成真相的一部分。`

## 2. 最短结论

从源码看，Claude Code 已经明显具备“投影差异是有意设计”的意识：

1. PromptInputFooter 注释明确写出 failed state 由 notification 承担，不在 footer pill 展示  
   `src/components/PromptInput/PromptInputFooter.tsx:173-185`
2. useReplBridge 明确把 bridge failed 定向写进 notification surface  
   `src/hooks/useReplBridge.tsx:102-112`
3. `/status` 注释明确说为了避免行数爆炸，只显示按 state 的 counts 与 `/mcp` hint  
   `src/utils/status.tsx:96-114`
4. BridgeDialog 则使用更完整的 status inputs，说明确实存在“更完整 surface”与“更窄 surface”的制度差异  
   `src/components/BridgeDialog.tsx:152-170`

这说明 projection difference 在系统内部已经被承认。  
但它大多仍停留在：

`代码注释与实现约束`

而没有被充分显化给用户。

所以这一章的最短结论是：

`Claude Code 已经有完成投影分层，但下一代安全控制台还应把这种投影盲区显式展示给用户。`

再压成一句：

`差异若不显化，分层就会被误解成不一致。`

## 3. bridge 域已经说明：有些投影差异在代码里是显式的，在用户界面上却仍是隐式的

## 3.1 footer 注释已经明确说：failed 不在这里显示

`src/components/PromptInput/PromptInputFooter.tsx:173-185` 写得非常直接：

1. failed state is surfaced via notification
2. not a footer pill
3. implicit remote only shows reconnecting

这说明作者非常清楚 footer 只是窄投影面。

换句话说，  
工程实现已经知道：

`这里没显示，不等于系统里不存在。`

## 3.2 但用户看到的只是“没显示”，而不是“因为这里没有权限显示”

这正是问题所在。

代码层知道：

`footer 不承担 failed 投影责任`

但用户界面上并没有一句明确提示告诉用户：

`失败信息被路由到通知层，这里故意不显示。`

于是用户只能自己从行为上反推：

`为什么这个位置空着`

这种认知负担本可以被显式消除。

## 3.3 BridgeDialog 的较完整性如果不被显式标注，也容易被误读成“唯一真相源”

`src/components/BridgeDialog.tsx:152-170` 里，  
BridgeDialog 显然拿到了更完整的 bundle：

1. statusLabel
2. statusColor
3. indicator
4. environment / session / URL 等上下文

这让它比 footer 更接近完整控制面。

但如果系统不显式告诉用户：

`Dialog 比 footer 看到得更多`

那么另一种误读就会出现：

`用户以为 Dialog 就等于完整真相源，而别处都是 bug。`

所以差异显化不是给弱 surface 加字，  
而是为了建立：

`各 surface 之间的解释边界`

## 4. MCP 域更明显：summary、notification、server menu 的差异若不显化，很容易被误读

## 4.1 `/status` 自己的注释已经承认：这里只给 summary，不给 detailed control plane

`src/utils/status.tsx:96-114` 的注释很关键：

1. 不想让 per-server rows 主导整个 Status pane
2. 所以 show counts by state + `/mcp` hint

这说明 `/status` 在制度上本来就是：

`aggregate projection`

它不是要回答：

1. 哪个 server connected
2. 哪个 server tools 缺失
3. 哪个 server needs-auth but almost ready

而只是给出 summary。

## 4.2 但如果 UI 不显式说“这是 summary”，用户就会天然把 count 当全貌

`1 connected, 1 need auth, 2 failed`

这种 count 很容易让用户产生错觉：

`我已经看见了全部 completion truth`

可其实并没有。  
因为 count 根本不包含：

1. 哪个 server 是哪个
2. 哪些 tools 可用
3. 哪个需要 `/mcp` auth，哪个只是重连

所以 `/status` 的差异显化，本应包含一句显式 meta：

`这里是 summary，详细控制与解释请去 /mcp。`

## 4.3 notification 只报异常态，如果不显式说明，也会被误读成“没报的都没问题”

`src/hooks/notifs/useMcpConnectivityStatus.tsx:30-63` 只发：

1. failed
2. needs-auth

它从不主动发：

`connected`

这说明 notification 只是：

`repair-needed projection`

但如果这层差异不显式说出，  
用户就可能误解成：

`没看到通知 = 全部都好`

而其实可能只是：

`这里不负责播报成功态`

## 5. 这说明下一代安全控制台不只要分层，还要显式承认自己在分层

从工程实现看，  
Claude Code 已经做了很多正确的分层。

但从产品语义看，  
它还可以再往前一步：

`把“本 surface 看到的是哪一类真相、看不到什么、下一步该去哪看”显式写出来。`

这可以通过至少三类方式实现：

1. 子标题 / 标签
   例如 `Summary only`、`Notifications only`、`Detailed control`
2. 缺失字段占位
   例如 `Failure details are shown in notifications`
3. 明确跳转文案
   例如 `For server-level detail, open /mcp`

这样一来，  
投影差异就不再只是工程内隐纪律，  
而会变成用户可理解的控制面语法。

## 6. 哲学本质：显式承认盲区，是控制面诚实性的高级形式

这一章最重要的哲学结论是：

`真正成熟的控制面，不是把所有差异藏起来假装统一，而是显式承认自己在某些位置看得不全。`

这和前面关于：

1. 未知语义
2. 承诺上限
3. 投影分层

其实是同一个伦理原则：

`不要让用户把你的局部视角误当成全知视角。`

所以差异显化并不是额外提示，  
而是：

`控制面诚实性的高级阶段`

## 7. 第一性原理：为什么“沉默”在这里是一种危险的设计

如果从第一性原理问：

`既然某个 surface 本来就不该看见全部真相，那什么都不说、直接少显示一点，不就行了吗？`

答案是：

`不行，因为用户天然会把“没显示”解释成“没有”。`

而一旦这样理解：

1. 窄投影会被误当全投影
2. hidden truth 会被误当不存在
3. 各 surface 之间会被误解成矛盾

因此沉默并不是中立选择，  
而是一种高风险默认。

安全控制面如果要真正诚实，  
就必须把：

`我这里看不到`

这件事本身也显式表达出来。

## 8. 苏格拉底式自我反思

可以继续问六个问题：

1. footer 是否应显式告诉用户“失败已转到通知层”？
2. `/status` 是否应明确标注“这里只做聚合 summary”？
3. notification 是否应附带“成功态不在此处展示”的说明，避免用户误读它是全量面板？
4. BridgeDialog 是否应说明自己比 footer 拥有更完整的 completion context？
5. MCPRemoteServerMenu 是否应显式解释“connected 不等于 effectively authenticated”的额外条件？
6. 下一代统一安全控制台是否应该把每个 surface 的 projection scope 做成显式字段，而不是只靠注释约束？

这些问题说明：

Claude Code 已经把分层做出来了，  
下一步最值得做的是：

`把分层说出来。`

## 9. 对目录结构与后续研究的启发

写到这里，这条资格安全链已经推进成九层：

1. 资格对象
2. 重签发路径
3. 中间态语法
4. 承诺上限
5. 默认动作路由
6. 错误路径禁令
7. 动作完成权
8. 完成投影
9. 完成差异显化

所以下一步最自然的深化方向会是：

`统一安全控制台的显式投影协议字段`

也就是把这些差异从论文式结论继续收敛成一个更可实现的字段体系。

## 10. 给系统设计者的技术启示

最后把这一章压成六条工程启示：

1. 有投影分层还不够，必须把分层显式告诉用户
2. `summary`、`notification`、`footer`、`dialog` 应有不同的 scope 声明
3. `没显示` 绝不能默认等于 `不存在`
4. 弱 surface 最好提供显式 handoff 到更强 surface
5. 强 surface 最好显式标识自己为何更强
6. 若不显化投影差异，用户最终会把诚实分层误解成系统不一致

这一章最终要守住的一条硬结论是：

`对 Claude Code 这类安全控制面来说，真正成熟的不是只把真相分层保存，而是把“我这里只看见了多少真相”也诚实地告诉用户。`
