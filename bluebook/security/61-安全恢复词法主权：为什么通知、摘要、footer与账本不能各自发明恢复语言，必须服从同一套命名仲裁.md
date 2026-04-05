# 安全恢复词法主权：为什么通知、摘要、footer与账本不能各自发明恢复语言，必须服从同一套命名仲裁

## 1. 为什么在 `60` 之后还要继续写“词法主权”

`60-安全恢复显式语义` 已经回答了：

`hidden、suppressed、cleared、resolved 必须严格区分，不能被同一句“没事了”压平。`

但如果继续往下一层追问，  
还会出现一个更接近控制面治理的问题：

`既然这些词必须区分，那么到底谁有资格给状态命名？`

因为只要系统里有多个界面、多个摘要层、多个提示层，  
就会自然出现一种新的风险：

`每个组件都开始用自己的话描述恢复状态。`

这时哪怕底层对象设计正确，  
控制面仍会被产品表层重新压坏。  
同一底层事实可能被说成：

1. `connected`
2. `active`
3. `installed`
4. `disconnected`
5. `failed`
6. `needs auth`

这些词并不总是错，  
但如果它们来自不同组件的各自发明，  
就会制造一种新的裂脑：

`事实账本是一套，恢复语言却变成了多套。`

所以在 `60` 之后，  
统一安全控制台还必须再补一条制度：

`恢复词法主权。`

也就是：

`不是每个看到局部状态的组件都有资格自己给恢复状态命名；不同层必须服从同一套词法仲裁与表达上限。`

## 2. 最短结论

从源码看，Claude Code 现在已经出现了明显的“多处命名、强度不一”的状态：

1. `useIdeConnectionStatus.ts` 把 IDE 压成 `connected / pending / disconnected / null`  
   `src/hooks/useIdeConnectionStatus.ts:4-32`
2. `useIDEStatusIndicator.tsx` 会进一步生成 `disconnected`、`plugin not connected`、`install failed` 等通知词  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:43-165`
3. `status.tsx` 又把同域状态压成 `Connected to ...`、`Installed ...`、`Not connected`  
   `src/utils/status.tsx:38-114`
4. `bridgeStatusUtil.ts` 更激进，直接把 `sessionActive || connected` 都压成 `Remote Control active`  
   `src/bridge/bridgeStatusUtil.ts:113-150`
5. `PromptInputFooter.tsx` 甚至明确写出：failed state 走 notification，不走 footer pill  
   `src/components/PromptInput/PromptInputFooter.tsx:173-189`
6. `useMcpConnectivityStatus.tsx` 与 `status.tsx` 对 MCP 又分别用 `failed / needs auth` 通知和 `n connected / n pending / n failed` 摘要  
   `src/hooks/notifs/useMcpConnectivityStatus.tsx:25-74`、`src/utils/status.tsx:89-114`

所以这一章的最短结论是：

`Claude Code 已经拥有多处状态命名入口，但尚未把“谁能说多满”正式收敛成一套统一词法主权。`

我会把这条结论再压成一句话：

`状态作者不等于命名作者，命名作者不等于解释作者。`

## 3. 源码已经显示：同一恢复事实正被多个组件以不同强度转述

## 3.1 IDE 域已经有至少三套词法

第一层是 `src/hooks/useIdeConnectionStatus.ts:4-32`。  
这里的基础词法是：

1. `connected`
2. `pending`
3. `disconnected`
4. `null`

第二层是 `src/hooks/notifs/useIDEStatusIndicator.tsx:43-165`。  
通知层继续把这些状态翻译成：

1. `${ideName} disconnected`
2. `IDE plugin not connected · /status for info`
3. `IDE extension install failed (see /status for info)`

第三层是 `src/utils/status.tsx:38-114`。  
摘要层又把同域状态说成：

1. `Connected to IDE extension`
2. `Installed IDE extension`
3. `Not connected to IDE`

这三套词法都不是完全错误，  
但它们显然不在同一个强度层。  
如果没有统一仲裁，  
用户就很容易把：

`Installed`

误读成：

`Connected`

再把：

`Connected`

误读成：

`Fully resolved`

## 3.2 bridge 域已经出现词法压缩过猛的迹象

`src/bridge/bridgeStatusUtil.ts:113-150` 很关键。  
这里直接把：

`sessionActive || connected`

压成同一句：

`Remote Control active`

而 `src/components/PromptInput/PromptInputFooter.tsx:173-189` 又说明：

1. failed state 不放 footer pill
2. 只把 `getBridgeStatus(...)` 的结果塞进 footer
3. implicit remote 甚至只显示 reconnecting

这说明 bridge 域当前已经存在一种明显的词法主权问题：

1. transport/readiness 层和 session/execution 层被压成同一个 `active`
2. footer 层只拿到裁剪后的词法子集
3. 失败态又被分流到 notification

这不是简单的 UI 选择问题，  
而是：

`不同组件正在消费不同强度的词法切片。`

如果系统没有统一规则，  
那每个入口都可能在不知不觉中越级说满。

## 3.3 MCP 域说明：通知词法与摘要词法已经天然分层，但还没被正式收编

`src/hooks/notifs/useMcpConnectivityStatus.tsx:25-74` 会输出：

1. `mcp failed`
2. `connector unavailable`
3. `needs auth`

而 `src/utils/status.tsx:89-114` 则只输出：

1. `n connected`
2. `n pending`
3. `n need auth`
4. `n failed`

这其实已经隐含一种成熟思想：

1. 通知词法偏动作导向
2. 摘要词法偏盘点导向

问题在于，  
这套分层目前更多是实现习惯，  
还不是正式制度。  
如果后续某个新组件直接把摘要词法说成“已恢复”，  
当前源码里并没有一套明确的命名仲裁去阻止它。

## 3.4 真正 authoritative 的 writer 反而并不直接负责对外命名

`sessionState.ts` 与 `ccrClient.ts` 负责的是：

1. `pending_action` 的 authoritative 写入和清空
2. `task_summary` 的 authoritative 清理
3. stale metadata cleanup
4. `worker_status`、delivery status 的正式账本写回

也就是说，  
真正最接近真相源的层，  
其实并没有在四处直接输出用户可见词法。  
这进一步说明：

`命名是一种单独的权力。`

如果这项权力不被正式治理，  
就会被最靠近界面的组件自然接管。  
而这些组件往往恰恰看不到全量账本。

## 4. 第一性原理：命名是一种解释主权，不是 UI 装饰

如果从第一性原理追问：

`为什么“谁来命名”要上升成一条安全原则？`

因为命名并不是中性的。  
当系统说出一个词时，  
它实际上在承诺：

1. 当前看到的是哪一层事实
2. 当前缺失了哪些账本
3. 当前有没有资格继续往更高层推断

所以命名的本质不是 UI 装饰，  
而是：

`解释主权的外显。`

这条原则可以压成一句话：

`谁有资格命名，决定了谁有资格定义用户眼中的当前真相。`

## 5. 我给统一安全控制台的“词法主权模型”

我会把它分成四条规则。

## 5.1 真相源层定义词法上限

authoritative writer 不一定直接输出文案，  
但必须定义：

1. 当前允许哪些词
2. 当前禁止哪些词
3. 当前表达 ceiling 到哪一层

## 5.2 投影层只能转述，不能自造更强词

BridgeDialog、`/status`、footer、notification 都可以：

1. 选词
2. 摘要
3. 降级

但不能：

1. 自造比真相源更强的词
2. 把低层 ready 说成高层 resolved

## 5.3 不同入口可以不同句式，但不能不同真值

通知、摘要、卡片、footer 可以有不同长度、不同交互导向，  
但它们必须共享：

1. 同一词法阶梯
2. 同一禁止词表
3. 同一 resolved 门槛

## 5.4 resolved 必须被保留给最高层 signer

任何 transport、summary、status count、notification disappearance 都不能单独产出：

`resolved`

这个词只能由真正的 explanation closure 产生。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性在于它已经拥有多层状态对象和多层界面，但下一步要真正成熟，必须把词法主权也收编进控制面。`

当前先进的地方有三点：

1. 底层状态与提示系统已经分层
2. 不同入口已经自然形成不同强度表达
3. 某些组件已经承认自己只展示状态子集

当前仍待系统化的地方也有三点：

1. `active / connected / installed / failed / needs auth` 的词法强弱还没统一编码
2. 同域不同入口之间仍可能出现表达上限不一致
3. 没有一张正式的“词法 ceiling / 禁止词 / 允许词”表给所有组件共享

这对其他 Agent 平台构建者的直接启示有五条：

1. 给状态设计 schema 时，同时设计词法 ceiling
2. 把命名权视为解释权的一部分
3. 给每个投影层定义“允许转述到哪一步”
4. 用共享枚举或策略表约束 status line、toast、card、footer 的可用词
5. 把 resolved、recovered、ready、connected 这些词做成强弱有别的正式对象，而不是自由文本

## 7. 哲学本质

这一章更深层的哲学是：

`谁控制词语，谁就控制了用户看到的现实。`

很多系统的失败并不在于底层没状态，  
而在于：

`每个界面都在替底层状态写自己的故事。`

结果就是：

1. 账本是分层的
2. 控制面是分层的
3. 但用户认知却被多个组件分别塑形

这种认知层裂脑，  
最终和状态层裂脑一样危险。

## 8. 苏格拉底式反思：这一章最需要追问什么

### 8.1 为什么不能让每个组件根据自己看到的状态自由发挥文案

因为它们看到的是账本子集，而不是全量真相。

### 8.2 如果多个入口都只是“差不多对”，为什么还不够

因为控制面需要的是可组合的一致真值，不是局部自洽的近似描述。

### 8.3 真正危险的错误是什么

不是某个词有点不优雅，  
而是：

`低层组件用更强词汇越级定义了高层恢复现实。`

### 8.4 这一章之后还缺什么

还缺一张更短的仲裁矩阵：

`surface -> visible inputs -> max allowed lexicon -> forbidden stronger terms`

也就是说，  
下一步最自然的延伸就是：

`appendix/45-安全恢复词法主权速查表`

## 9. 结语

`60` 回答的是：控制面必须保留 hidden、suppressed、cleared、resolved 四类词。  
这一章继续推进后的结论则是：

`这些词还必须有主权边界，不是每个界面都能随意命名恢复状态。`

这意味着 Claude Code 更深层的安全启示之一是：

`成熟控制面不仅要有正确对象、正确 signer、正确词汇，还要有正确的命名权分配。`
