# 安全恢复中间态：为什么系统必须显式区分write-only、mirror-only、restored-but-not-fresh，而不是统一说已恢复

## 1. 为什么在 `50` 之后还要继续写“恢复中间态”

`50-安全恢复签字层级` 已经回答了：

`不同强度的恢复证据分别只配恢复不同层级对象。`

但如果继续往下追问，  
还会出现一个更贴近产品化和宿主治理的问题：

`当系统只恢复到一半时，它到底该怎么说自己现在处于什么状态？`

因为只要源码里存在：

1. 只开写链、不读回的模式
2. 旧状态已接回、但还不是 fresh 的模式
3. 只支持窄 control subtype 的宿主
4. 结果可能已出、但副作用尚未全部完成的阶段

那控制面就不该只有两档词：

1. 已失败
2. 已恢复

如果它继续这样做，  
用户就会被逼着把所有“部分恢复”都误读成：

`全面恢复`

所以在 `50` 之后，  
统一安全控制台还必须再补一条制度：

`恢复中间态必须显式可见。`

也就是：

`系统必须正式承认“现在恢复到了哪一半”，而不是把所有半恢复状态压成同一个绿色词。`

## 2. 最短结论

从源码看，Claude Code 至少已经存在四类非常明确的中间态：

1. `mirror-only / outbound-only`  
   `src/bridge/replBridgeTransport.ts:142-147,336-345`
2. `write-ready but not read-ready`  
   `src/bridge/replBridgeTransport.ts:289-299`
3. `restored-but-not-fresh`  
   `src/cli/transports/ccrClient.ts:474-522`、`src/cli/print.ts:5048-5058`
4. `control-narrow`  
   `src/server/directConnectManager.ts:81-98`、`src/remote/RemoteSessionManager.ts:192-213`

但展示层同时又存在一个强压缩点：

`src/bridge/bridgeStatusUtil.ts:123-140`

它会把：

1. `sessionActive`
2. `connected`

统一压成：

`Remote Control active`

所以这一章的最短结论是：

`Claude Code 底层已经承认部分恢复与窄恢复，但展示层仍有把它们压平为“active/connected”的冲动；下一代统一安全控制台必须把这些中间态对象正式化。`

## 3. 源码已经明确存在“不是全恢复”的多种中间态

## 3.1 mirror-only / outbound-only：写路径存在，但不会接收入站控制

`src/bridge/replBridgeTransport.ts:142-147` 写得非常清楚：

1. `outboundOnly` 为真时
2. 不打开 SSE read stream
3. 只激活 CCRClient write path
4. 用于 mirror-mode attachments
5. 不会接收入站 prompt 或 control request

`src/bridge/replBridgeTransport.ts:336-345` 又进一步说明：

1. outbound-only 会跳过读流
2. 只保留 `POST /worker/events` 与 heartbeat

这就是一种非常标准的中间态。  
它已经不是“完全断了”，  
但也绝不是“完整恢复”。

它更准确的名字只能是：

`mirror-only`

或：

`write-only attachment`

因为它真正恢复的只是：

1. 事件转发
2. 写路径

而没有恢复：

1. 入站交互
2. control request 接收
3. 完整读回

## 3.2 write-ready but not read-ready：connected 只是半个 ready

`src/bridge/replBridgeTransport.ts:289-299` 更关键。  
源码直接写出：

1. `isConnectedStatus()` 是 write-readiness
2. 不是 read-readiness
3. `getStateLabel()` 也只是根据有限可观察信息合成

这说明 “connected” 在这里不是一个完整结论，  
而只是：

`写链已就绪`

这是一种比 mirror-only 略厚、  
但仍然显著薄于“完整恢复”的中间态。

如果控制面继续把它说成：

`已恢复`

那用户会自然误解为：

1. 结果会回来
2. 入站 control 会回来
3. 读写都恢复

所以这种状态更适合被正式命名成：

`write-ready / read-blind`

## 3.3 restored-but-not-fresh：旧状态接回了，但当前新鲜性还不能说满

`src/cli/transports/ccrClient.ts:474-522` 说明：

1. 初始化时会并发取回旧 worker state
2. 先成功 `PUT /worker`
3. 清 stale metadata
4. 之后才记录 `state_restored`

`src/cli/print.ts:5048-5058` 又明确写道：

`Await restore alongside hydration so SSE catchup lands on restored state, not a fresh default.`

这意味着源码已经在明确区分两件事：

1. 旧状态重新接回
2. 当前状态已经 fresh

前者成立时，  
系统最多只能说：

`restored`

不能立即说：

`fresh`

因为恢复链此时仍可能处于：

1. hydrate 追赶中
2. 新一轮回读未完成
3. 某些盲区尚未缩小

所以这一类最准确的中间态名字只能是：

`restored-but-not-fresh`

## 3.4 control-narrow：宿主恢复了连接，但仍只支持窄控制面

`src/server/directConnectManager.ts:81-98` 和 `src/remote/RemoteSessionManager.ts:192-213` 都说明：

1. 它们只正式处理 `can_use_tool`
2. 其他 control request subtype 会被显式拒绝

这意味着某些宿主即使：

1. 已连接
2. 能处理权限请求

也仍然只恢复到了：

`control-narrow`

而不是：

`control-complete`

这是另一类非常标准的中间态。  
它比完全断开强，  
但也比完整控制宿主薄得多。

如果展示层继续把它压成：

`connected`

那用户会误以为：

`协议全集都回来了`

## 3.5 effect-pending：结果已出，但后效应还未全到

`src/cli/print.ts:2261-2267` 单独发 `files_persisted`，  
正说明：

1. 结果产生
2. 文件落盘

不能被混成同一时刻。

这意味着在 result 已到、`files_persisted` 未到之前，  
控制面实际上又处于一种中间态：

`result-ready / effects-pending`

它也不该被压成一个统一的“完成”。

## 4. 展示层仍然有把中间态压平的冲动

## 4.1 `Remote Control active` 是一个典型压缩点

`src/bridge/bridgeStatusUtil.ts:123-140` 会把：

1. `sessionActive`
2. `connected`

统一压成：

`Remote Control active`

这在简洁性上当然有价值，  
但它也带来一个明显风险：

`多个语义厚度不同的中间态，被压成了同一个成功词。`

具体来说，  
下面几种状态都很容易被这个 label 吃掉：

1. 只是 write-ready
2. outbound-only
3. restored 但不 fresh
4. 宿主只支持窄 control subtype

所以这类总体标签如果不配套中间态字段，  
几乎必然会制造假完整。

## 4.2 BridgeDialog 目前更擅长“摘要”，不擅长“中间态命名”

`src/components/BridgeDialog.tsx:137-156` 读取的主要仍是：

1. `connected`
2. `sessionActive`
3. `reconnecting`
4. `error`

这意味着它今天主要处理的是：

`失败 / 重连 / active / connecting`

这四类摘要态。  
而不是：

`mirror-only`
`write-ready/read-blind`
`restored-but-not-fresh`
`control-narrow`

也就是说，  
BridgeDialog 现在已有状态零件，  
但还没有中间态词汇表。

## 5. 第一性原理：部分恢复如果没有名字，就会被误认为完全恢复

如果从第一性原理追问：

`为什么中间态必须显式命名？`

因为用户看到控制面时，  
一定会自动做二选一判断：

1. 还不行
2. 已经好了

如果系统自己不提供“第三种、第四种、第五种”正式状态，  
用户就只能把所有中间态都塞进：

`已经好了`

所以成熟系统真正要治理的，不只是恢复本身，  
而是：

`恢复被如何分档叙述。`

我会把这条原则压成一句话：

`没有名字的部分恢复，最终都会被用户读成完全恢复。`

## 6. 我给统一安全控制台的恢复中间态词汇表

我会把最少需要产品化的中间态压成五类。

### 6.1 `mirror-only`

含义：

1. 仅转发或上送事件
2. 不接收入站 prompt / control

适用证据：

1. `outboundOnly`

禁止文案：

1. `Remote Control active`
2. `Fully connected`

更安全文案：

`Attached (mirror-only)`

## 6.2 `write-ready / read-blind`

含义：

1. 写链可用
2. 读链未被同等证明

适用证据：

1. `isConnectedStatus()` 仅签 write-readiness

禁止文案：

1. `Connected`
2. `Recovered`

更安全文案：

`Write path ready; read path unproven`

## 6.3 `restored-but-not-fresh`

含义：

1. 旧状态已接回
2. fresh 回读与当前新鲜性未被说满

适用证据：

1. `state_restored`
2. `restoredWorkerState`
3. restore/hydrate 排序已正确

禁止文案：

1. `Up to date`
2. `Fully restored`

更安全文案：

`Restored; awaiting fresh state`

## 6.4 `control-narrow`

含义：

1. 宿主在线
2. 仅支持狭窄 control subset

适用证据：

1. 只支持 `can_use_tool`
2. 其他 subtype unsupported

禁止文案：

1. `Remote control ready`
2. `Control channel restored`

更安全文案：

`Permission-only control host`

## 6.5 `result-ready / effects-pending`

含义：

1. 结果已到
2. 副作用签字未到齐

适用证据：

1. result 已发
2. `files_persisted` 未到

禁止文案：

1. `Completed`
2. `All changes applied`

更安全文案：

`Result delivered; persistence pending`

## 7. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不只是会做严格恢复签字，更在于源码本身已经暴露出足够多的中间态证据，只差把它们产品化。`

这套设计最值得别的 Agent 平台借鉴的地方有五点：

1. 模式不必非黑即白，协议可以诚实暴露半恢复状态
2. write/read 分裂比“connected”更真实
3. restore 与 fresh 应是两级状态，不应合并
4. 宿主子集能力必须显式叫出自己的窄身份
5. result 与 effects 应继续分层，不应被统一说成完成

## 8. 哲学本质

这一章更深层的哲学是：

`诚实的系统不只是承认失败，也承认不完整的恢复。`

很多系统看起来不诚实，  
不是因为它们故意撒谎，  
而是因为它们没有为“部分恢复”保留语言位置。  
Claude Code 源码里那些关于 outbound-only、write-readiness、restore/hydrate、unsupported subtype、files persisted 的细节，  
其实共同指向同一条更成熟的哲学：

`恢复不是从红到绿的一次跳变，而是一条需要被命名的连续光谱。`

从第一性原理看，  
这保护的是下面这条公理：

`如果部分恢复没有自己的正式语义，控制面最终一定会用“已恢复”去掩盖它。`

## 9. 苏格拉底式反思：这一章最容易犯什么错

### 9.1 会不会中间态太多，用户反而看不懂

会。  
所以关键不是无限增词，  
而是只保留那些真正会改写动作与解释权限的中间态。

### 9.2 会不会又把中间态做成新的技术黑话

也会。  
所以每个中间态必须绑定：

1. 它到底缺哪条链
2. 还能做什么
3. 不能做什么
4. 下一步去哪修

### 9.3 这一章之后还缺什么

还缺一张中间态矩阵：

`中间态 -> 可见账本 -> 可用动作 -> 禁止文案 -> 默认跳转`

也就是说，  
下一步最自然的延伸就是：

`appendix/35-安全恢复中间态速查表`

## 10. 结语

`50` 回答的是：不同 signer 分别只配恢复不同层级对象。  
这一章继续推进后的结论则是：

`控制面还必须把那些“只恢复到一半”的状态正式命名出来，避免它们被统一压成已恢复。`

这意味着 Claude Code 更深层的安全启示之一是：

`真正成熟的安全控制面，不只会说“还没好”或“已经好”，还会诚实地说清楚“现在只好了哪一半”。`
