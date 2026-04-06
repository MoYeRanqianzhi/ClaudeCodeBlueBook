# 安全偏斜算子主权：为什么nudge、retag、split-key、no-op、kill-switch、block、reject与fence不能由任意层随意选择

## 1. 为什么在 `143` 之后还必须继续写“算子主权”

`143-安全偏斜处置算子` 已经回答了：

`Claude Code 不只是能识别 skew object，还已经把不同错位压成了 nudge、retag、split-key、no-op、kill-switch、block、reject 与 fence 这些 remediation operator。`

但如果继续追问，  
还会碰到一个更关键的控制面问题：

`既然算子已经存在，谁有资格选择哪一个算子？`

因为真正危险的地方往往不是：

`系统没有这个 operator`

而是：

`系统让错误的层使用了错误的 operator`

例如：

1. 如果 UI 层可以自行 `block`
2. 如果 compat adapter 可以自行 `reject`
3. 如果弱 surface 可以自行 `fence`
4. 如果 decoder 层只能做 `nudge`

那系统就会立刻陷入：

1. 过度阻断
2. 越权改口
3. 双重真相
4. stale world 回魂

所以 `143` 之后必须继续补的一层就是：

`安全偏斜算子主权`

也就是：

`成熟安全系统不仅要有 operator grammar，还必须把每个 operator 绑定到最靠近真相与后果的边界，由对应 signer 层来执行。`

## 2. 最短结论

Claude Code 当前源码已经清楚展示出一种很强的 operator sovereignty 分布：

1. 展示层只配发 `nudge`，不配越级把 cosmetic 问题升级成 init failure  
   `src/hooks/useReplBridge.tsx:607-614`
2. compat adapter 层配做 `retag / translate`，让上层调用方可以继续持有“自己手上的对象”  
   `src/bridge/createSession.ts:357-360`
3. transport adapter 层配把高代际能力降为 `no-op`，而不是伪造成功  
   `src/bridge/replBridgeTransport.ts:51-64`
4. bootstrap / gate 层配决定 `kill-switch` 与 `block`  
   `src/bridge/initReplBridge.ts:130-134,410-420,456-460`
5. decoder 层配执行 `reject`  
   `src/bridge/workSecret.ts:5-18`
6. runtime / scheduler / transport rebuild 边界配执行 `fence` 与 `flush gate`  
   `src/bridge/replBridge.ts:1111-1124,1373-1426`  
   `src/bridge/jwtUtils.ts:176-183`  
   `src/bridge/remoteBridgeCore.ts:482-487`

这些证据合在一起说明：

`Claude Code 真正成熟的地方不只在于“有这些 operator”，还在于“operator 被分配给了正确的边界”。`

因此这一章的最短结论是：

`cleanup future design 若要进一步工程化，不能只设计 operator matrix，还必须设计 operator authority matrix，明确哪些层只配提示，哪些层配翻译，哪些层配阻断、拒绝与 fencing。`

再压成一句：

`安全控制面的高级形态，不是动作更多，而是动作主权更清晰。`

## 3. 第一性原理：为什么正确动词若落到错误层，仍然是错误系统

如果一个系统最终执行了一个看似正确的动作，  
例如：

`reject`

但它是由错误的层发出的，  
那它仍可能是一个错误系统。

从第一性原理看，  
安全动作的正确性不只取决于：

1. 动词是否正确

还取决于：

1. 谁有资格说这句话
2. 这个层是否掌握了足够真相
3. 这个层是否承担了相应后果
4. 这个层是否有权修改别层的承诺

所以成熟控制面必须同时回答两件事：

1. `what operator`
2. `which operator signer`

否则会出现经典错位：

1. 只看得见可见性问题的层去阻断路径
2. 只懂 compat costume 的层去判 grammar 非法
3. 只懂局部状态的层去丢弃全局世界
4. 只会消费的层去决定 schema 退场

所以从第一性原理看：

`operator grammar 给出动词表，operator sovereignty 决定谁配发号施令。`

## 4. 展示层只配 `nudge`，不配把 cosmetic skew 升级成系统阻断

`src/hooks/useReplBridge.tsx:607-614` 很有代表性：

1. bridge 初始化已成功
2. 代码只是追加 `createBridgeStatusMessage(...)`
3. 注释还明确写：
   `Own try/catch so a cosmetic GrowthBook hiccup doesn't hit the outer init-failure handler`

这说明在 Claude Code 里，  
展示层被赋予的主权是：

1. 可以追加提示
2. 可以帮助用户理解当前状态
3. 但不应因为一个 cosmetic nudge 失败，就污染真正的 init path

也就是说：

`UI 层拥有 nudge 主权，但不拥有 block 主权。`

这点非常重要。  
因为很多系统会在 UI 层偷放过强动作，  
最终把：

`显示层的解释性动作`

变成：

`控制层的资格动作`

而源码这里恰恰显式避免了这一点。

## 5. compat adapter 层配 `retag / translate`，因为它最懂 costume 而不是最懂真相

`src/bridge/createSession.ts:357-360` 很清楚：

1. compat gateway 只接受 `session_*`
2. v2 caller 会传 `cse_*`
3. 所以这里明确：
   `retag here so all callers can pass whatever they hold`
4. 且强调它对既有 compat form 是 idempotent

这说明 `retag` 的主权不在调用方，  
也不在 UI，  
而在：

`最靠近兼容网关、最懂 costume translation 的 adapter layer`

这层并不负责判：

1. 这个对象是否合法
2. 这条路径是否有资格
3. 这是不是 foreign session

它只负责：

`如果只是穿错衣服，我来给它换回当前门禁认得的衣服。`

所以从主权角度看：

`translate 属于 adapter sovereignty，不属于 policy sovereignty。`

## 6. transport adapter 层配 `no-op`，因为它最清楚当前代际缺了哪段能力

`src/bridge/replBridgeTransport.ts:51-64` 明确写：

1. `reportState`  
   `v2 only; v1 is a no-op`
2. `reportMetadata`  
   `v2 only; v1 is a no-op`
3. `reportDelivery`  
   `v2 only; v1 is a no-op`

这里最值得注意的是：

`no-op` 不是由上层业务代码随便决定的。

而是由 transport adapter 自己声明：

1. 哪些能力属于更高代际
2. 哪些在当前代际只是 intentional no-op

这说明：

`no-op 的主权属于最了解“当前 transport actually can do what”的那一层。`

如果把这件事交给上层 UI 或业务逻辑，  
就很容易把：

1. 真正的“当前 transport 不支持”
2. 暂时的“这次调用没执行”

混成同一种沉默。

## 7. bootstrap / gate 层配 `kill-switch` 与 `block`

### 7.1 `kill-switch` 由 init/gate 层注入，而不是由下游随手切

`src/bridge/initReplBridge.ts:130-134` 非常关键：

1. `setCseShimGate(isCseShimEnabled)`
2. 注释说明这是把 GrowthBook gate 接到 compat shim 上
3. 且特别指出 daemon / SDK paths skip this，shim 默认 active

这说明：

`kill-switch` 的主权不在每个调用点，

而在：

`能看见 rollout gate、知道哪些 path 参与这次 rollout 的 bootstrap layer`

### 7.2 `block` 也由 init/gate 层行使，因为它决定路径是否有资格启动

`src/bridge/initReplBridge.ts:410-420,456-460` 又展示了 `block` 主权：

1. min-version 不满足
2. `version_too_old`
3. failed
4. `return null`

这说明 `block` 不该由：

1. UI 提示层
2. compat translation 层
3. decoder 层

来擅自执行。

因为 `block` 的本质是：

`决定某条路径是否有资格进入控制面。`

这个决定天然应由 bootstrap/gate 边界签发。

## 8. decoder 层配 `reject`，因为它最靠近 grammar 真相

`src/bridge/workSecret.ts:5-18` 是一个很标准的 decoder sovereignty 例子：

1. 先 decode
2. 再验证 `version`
3. 不满足就直接抛：
   `Unsupported work secret version`

这里做得很对的一点是：

`reject` 没有被延后到更上层。

它不是：

1. 先让对象流进系统
2. 后面哪个层发现不对再报 generic error

而是：

`在最靠近 grammar 边界的 decoder 处当场拒绝。`

这说明：

`reject 的主权属于 grammar boundary，不属于 display boundary，也不属于 compat adapter boundary。`

## 9. identity guard 配 `reject foreign`，但只在 runtime pairing 边界行使

`src/bridge/replBridge.ts:1111-1124` 展示了另一个很细的主权分配：

1. 代码先强调 server 不该把别的环境 session 派给你
2. 然后又强调比较应基于 underlying UUID，而不是 tag prefix
3. 真正不匹配时才：
   `Rejecting foreign session`

这说明 foreign reject 并不是 decoder 的 grammar reject，  
也不是 compat adapter 的 retag。  
它属于：

`runtime pairing boundary 的身份守卫主权`

这层最懂的是：

1. 当前 environment/session 配对承诺
2. 哪种 mismatch 只是 costume
3. 哪种 mismatch 才是真 foreign reassignment

所以这里再次说明：

`同样叫 reject，不同 reject 也有不同 signer 层。`

## 10. `fence` 与 `flush gate` 必须由最靠近异步写权的层执行

### 10.1 handshake fence 由 transport orchestrator 执行

`src/bridge/replBridge.ts:1373-1426` 里：

1. generation bump
2. stale handshake 对比
3. `discarding stale handshake`
4. `t.close()`

这套逻辑不可能安全地下放到 UI。  
因为只有 transport orchestrator 知道：

1. 当前 generation 是多少
2. 旧 transport 是否还持有写权
3. 关闭哪个对象会不会误伤 current world

### 10.2 stale refresh fence 由 scheduler 执行

`src/bridge/jwtUtils.ts:176-183` 里：

1. await 之后重新比对 generation
2. stale 就 `skipping`

这里又说明：

`fence` 的主权属于异步调度边界。`

因为只有 scheduler 知道：

1. 这是旧 timer 还是当前 timer
2. 这次 refresh 还有没有资格安排 follow-up timer

### 10.3 flush gate 由 rebuild 边界执行

`src/bridge/remoteBridgeCore.ts:482-487` 更进一步：

1. transport rebuild 前先 `flushGate.start()`
2. 目的不是解释状态
3. 而是防止 closed uploader silent no-op 造成 permanent loss

这说明：

`flush gate 的主权属于世界切换边界。`

因为只有那一层最清楚：

1. 什么时候旧世界已经 stale
2. 什么时候必须先暂停写流
3. 什么时候可以重新放行

## 11. 一张更完整的 operator authority matrix

综合以上源码，可以压出这样一张主权矩阵：

1. UI / presentation layer -> `nudge`
2. compat adapter layer -> `retag / translate`
3. config-generation layer -> `split-key`
4. transport adapter layer -> `no-op`
5. bootstrap / rollout gate layer -> `kill-switch`, `block`
6. decoder / grammar boundary -> `reject`
7. runtime pairing boundary -> `reject foreign`
8. transport / scheduler / rebuild boundary -> `fence`, `flush gate`

这张矩阵最重要的意义在于：

`它把“哪个 operator 正确”继续推进成“哪个 operator 由谁签发才正确”。`

## 12. 对 cleanup future design 的直接启示

cleanup future rollout 若继续推进，  
最值得补的已经不是更多字段，  
而是：

`cleanup operator sovereignty map`

一个更成熟的 cleanup 设计很可能需要明确：

1. 哪些 cleanup visibility 问题只允许 UI `nudge`
2. 哪些 cleanup carrier mismatch 只允许 adapter `translate`
3. 哪些 cleanup unsupported action 只允许 transport / host adapter `no-op`
4. 哪些 cleanup contract floor mismatch 只允许 bootstrap `block`
5. 哪些 cleanup proof envelope mismatch 只允许 decoder `reject`
6. 哪些 stale cleanup ack / stale cleanup signer 只允许 scheduler / orchestrator `fence`

这些对象是基于现有 operator sovereignty 哲学做的推导，  
不是当前源码中已经存在 cleanup-specific signer map。

## 13. 我们当前能说到哪一步，不能说到哪一步

基于当前可见源码，  
我们可以稳妥地说：

1. Claude Code 已拥有一套相当清晰的 operator sovereignty 分布
2. 不同层各自掌握不同强度与不同语义类型的 remediation operator

但我们不能说：

1. cleanup operator sovereignty map 已经被正式编码
2. cleanup signer matrix 已经存在 schema / contract / conformance 级实现

所以这一章的结论必须压在：

`Claude Code 已展示出“正确 operator 必须由正确边界签发”这套工程哲学；cleanup future design 若要继续成熟，下一步最值得照抄的不是某个字段，而是这张 operator authority map。`

## 14. 苏格拉底式追问：如果这章还要继续提高标准，还缺什么

还可以继续追问六个问题：

1. cleanup foreign-ack reject 应属于 pairing boundary 还是 decoder boundary
2. cleanup downgrade note 应由 UI signer 还是 host adapter signer 负责
3. cleanup split-key 何时该升级成 formal contract version
4. fence 触发后，哪个层配宣布“旧 cleanup 世界已失效”
5. kill-switch 的退场标准应由谁签字
6. conformance tests 是否应开始验证“某 operator 不得由错误层触发”

这些问题说明：

`143` 解决的是“有哪些动词”，`144` 解决的则是“谁配说这些动词”。
