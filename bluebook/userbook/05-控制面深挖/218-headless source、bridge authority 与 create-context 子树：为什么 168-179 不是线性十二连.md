# `headless source`、bridge authority 与 create-context 子树：为什么 `168-179` 不是线性十二连

## 用户目标

继续往 `168-179` 读时，读者最容易留下一个新的线性误判：

- `168` 先讲 headless transport
- `169` 再讲 continue / resume 来源
- `170`、`171` 继续补 print source
- `172` 之后一路转向 bridge env / provenance / createSession
- `178`、`179` 最后顺手补 `session_context`

于是正文就会滑成一句看似自然、实际上过粗的话：

- “`168-179` 只是从 headless resume 一路走到 bridge context 的线性十二连。”

这句不稳。

从当前源码与现有 leaf 页看，更稳的结构不是：

- 一条线性十二连

而是：

1. `168` = 与 `169` 邻接的前置厚度轴
2. `169` = continuation-source 根页
3. `170 -> 171` = headless source certainty / local artifact provenance 分支
4. `172` = bridge continuity authority 根页
5. `173 -> 174` = environment truth / register authority 主干
6. `175` 与 `176` = 挂在 `174` 区域下的 sibling zoom
7. `177` = `175 × 176` 的交叉 zoom
8. `178 -> 179` = `176` 下的 `session_context` / git-context 分支

所以这页要补的不是更多 leaf-level 证明，

而是先把 `168-179` 写成：

- 一个邻接前置轴、两条接续分支与一棵 bridge create-context 子树

而不是：

- 一条线性十二连

## 第一性原理

更稳的提问不是：

- “`168-179` 最后到底讲的是 headless resume 还是 bridge createSession？”

而是先问六个更底层的问题：

1. 我现在写的是 host thickness，还是 continuation source？
2. 当前 source 是 stable conversation history、headless remote-hydrated transcript，还是 bridge pointer continuity？
3. 当前字段在回答 environment truth、provenance label，还是 session-create field / `session_context` payload？
4. 当前页是前一页的 zoom，还是已经换成新的根页？
5. 如果几个路径最后共享同一个 helper / variable，它们 upstream authority 真的一样吗？
6. 如果几个字段同在一个 request body 或 typed bag 里，它们 consumer 主语真的一样吗？

只要这六轴先拆开，

后面就不会再把：

- `168` 的厚度轴
- `169` 的 source root
- `170 -> 171` 的 print source 分支
- `172 -> ... -> 179` 的 bridge authority / create-context 子树

压成同一条编号尾巴。

## 第二层：更稳的结构是“邻接前置轴 + 两条接续分支 + create-context 子树”

更稳的读法是：

```text
167 metadata readback / local admission split
├─ 168 headless transport thickness                  [邻接前置轴]
└─ 169 continuation-source root                      [新根页]
   ├─ stable conversation source                     [留在 169 根句]
   ├─ 170 headless source certainty                  [分支根页]
   │   └─ 171 local artifact provenance              [zoom]
   └─ 172 bridge continuity authority                [分支根页]
       └─ 173 environment truth layering             [zoom root]
           └─ 174 register-chain env authority zone  [主干]
               ├─ 175 provenance label / trust / identity [sibling zoom]
               └─ 176 createSession field authority  [sibling zoom / 子根页]
                   ├─ 177 session source vs env label [175 × 176 交叉 zoom]
                   └─ 178 session_context split       [子分支根页]
                       └─ 179 git declaration vs branch projection [zoom]
```

这里真正该记住的一句是：

- `168` 先钉 headless thickness
- `169` 再把问题换成 continuation source
- `170 -> 171` 与 `172 -> ... -> 179` 才是从 `169` 分出去的两条不同接续分支

## 第三层：`168` 是邻接前置轴，不是 `169` 的父页

`168` 先回答的是：

- `StructuredIO` / `RemoteIO` 同属 headless protocol family
- 但 protocol runtime、recovery ledger、persistence backpressure 不是同一种厚度

它保护的稳定根句不是：

- headless remote 只是多几个恢复 helper

而是：

- same headless protocol family does not mean same recovery thickness

因此更稳的结构不是：

- `168 -> 169` 父子两页

而是：

- `168` 作为 `169` 的邻接前置轴
- 它提供背景，但不直接长出 `169`

没有这一步，

后面很容易把 `RemoteIO` / internal-event flush / `print --resume` 全部混写成：

- “同一种 headless resume 宿主”

## 第四层：`169` 是接续来源根页，不是 `168` 的尾注

`169` 真正换掉的主语是：

- “headless transport 有多厚”

转而开始问：

- 这些 continue / resume 到底在继续什么 source

它先把更宽的接续来源拆成：

1. stable conversation history source
2. conditional remote-hydrated transcript source
3. bridge pointer continuity source

因此 `169` 的稳定根句不是：

- headless remote resume 还有几个实现分支

而是：

- same continue / resume wording does not mean same continuation source

这里还要特别保护一件事：

- stable conversation source 留在 `169` 根句里

不需要再为它额外造一张 leaf 页；

真正继续下钻的是：

- `170 -> 171`
- `172 -> ... -> 179`

## 第五层：`170 -> 171` 是 headless source 分支，不是 bridge authority 的前戏

`170` 先把同属 `print` host 的 source certainty 拆成三层：

- implicit recent local
- explicit local artifact
- conditional remote materialization

所以它的根句不是：

- `print --continue` 和 `print --resume` 只是自动 / 手动之分

而是：

- same headless host still does not mean same source certainty

`171` 则没有继续讲全部 certainty，

它只把 `170` 里的 explicit local artifact family 再拆开：

- session-registry-backed local artifact
- transcript-file-backed local artifact

所以 `171` 更准确的位置不是：

- `172` 之前的编号过渡页

而是：

- `170` 下面对 explicit local artifact provenance 的 zoom

这里最该保护的一句是：

- `171` 讲的是 local artifact provenance

不是：

- remote hydrate

更不是：

- bridge continuity authority

## 第六层：`172` 打开 bridge continuity authority，`173 -> 174` 是 env truth / register authority 主干

`172` 先把 bridge reconnect family 的 upstream authority 拆成：

- pointer-led continuity authority
- explicit original-session authority

所以它的根句不是：

- `remote-control --continue` 只是 `--session-id` 的语法糖

而是：

- downstream reconnect machinery 可以共享，upstream authority 仍然不同

`173` 再把这条 authority 主干里的 env truth layering 拆成：

- pointer env hint
- server session env
- registered live env result

`174` 则继续只追：

- register chain 内部的 environment authority
- local config key / request-side reuse claim / live env / session attach target

所以更稳的结构不是把 `172/173/174` 写成：

- “bridge 恢复时一路看 env”

而是：

- `172` 先问 authority
- `173 -> 174` 才是 authority 下面的一条 env truth / register authority 主干

## 第七层：`175` 与 `176` 是挂在 `174` 区域下的 sibling zoom，`177` 是交叉 zoom

`175` 的主语已经不是：

- 哪个 env 才是真

而是：

- `BridgeWorkerType`
- `metadata.worker_type`
- `BridgePointer.source`
- `environment_id`

为什么不是同一种 provenance

所以它保护的是：

- origin label
- local prior-state trust domain
- environment identity

这说明 `175` 更准确的位置不是：

- `174` 的 env authority appendix

而是：

- `174` 区域下的 provenance sibling zoom

`176` 则把问题切到另一组 session-side field：

- `environment_id`
- `source`
- `session_context`
- `permission_mode`

为什么不是同一种 createSession field authority

所以更稳的结构不是：

- `175 -> 176` 线性两页

而是：

- `175` 与 `176` 都挂在 `174` 区域下
- 一个守 provenance taxonomy
- 一个守 createSession field authority

`177` 又继续只追：

- `createBridgeSession.source`
- environment-side `worker_type`

为什么不是同一种 remote provenance

所以 `177` 更稳的位置不是：

- `176` 的唯一后继

而是：

- `175 × 176` 的交叉 zoom

## 第八层：`178 -> 179` 是 `176` 下的 `session_context` / git-context 分支

`178` 先把：

- `sources`
- `outcomes`
- `model`

拆成三种上下文主语。

`179` 再继续只问：

- repo declaration
- branch projection

是不是同一种 git context。

所以更稳的结构不是：

- `176 -> 177 -> 178 -> 179`

而是：

- `176` 下面先分 `177`
- 再另开 `178 -> 179`

其中 `179` 更准确的位置不是：

- `177` 的来源字段补充

而是：

- `178` 的 git-context zoom

## 第九层：这些分支不能互相偷换

### `170/171` 不能偷换成 `172/...`

因为前者回答的是：

- headless host 内部的 source certainty / local artifact provenance

不是：

- bridge continuity authority

### `173/174` 不能偷换成 `175`

因为前者回答的是：

- env truth / register authority

后者回答的是：

- provenance label / trust-domain / identity

### `175/177` 不能被压回同一种 provenance

因为：

- `175` 先分的是 environment provenance taxonomy
- `177` 才继续只盯 session-side `source` 与 environment label 的错位

### `178/179` 不能再被写回 env truth 或 bridge authority

因为它们回答的是：

- `session_context` payload
- repo declaration vs branch projection

不是：

- bridge resume target
- env claim
- pointer cleanup

## 第十层：稳定 / 条件 / 灰度保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `168` = 邻接前置厚度轴；`169` = continuation-source 根页；`170 -> 171` = headless source 分支；`172` = bridge-authority 根页；`173 -> 174` = env-truth / register-authority 主干；`175` 与 `176` = `174` 区域下的 sibling zoom；`177` = provenance 交叉 zoom；`178 -> 179` = `176` 下的 `session_context` / git-context 分支 |
| 条件公开 | `print --resume url` 的 remote materialization、CCR v2 internal-event thickness、`remote-control --continue` 的 pointer continuity、`.jsonl` 的 transcript-file provenance、assistant-mode `worker_type` label |
| 内部/灰度层 | internal-event flush cadence、pointer fanout / cleanup heuristic、env mismatch fallback、`claude/${branch || 'task'}` 命名与部分 typed readback 面的具体暴露 |

## 苏格拉底式自审

### 问：我现在写的是 thickness、source，还是 createSession / `session_context`？

答：如果一句话说不清自己属于哪一层，就不要落字。

### 问：我是不是因为几个路径最后共享 `loadConversationForResume()` / `reconnectSession()`，就把 upstream authority 写成同一种？

答：先分 source / authority，再谈 shared machinery。

### 问：我是不是把 `175` 和 `177` 都写成“来源标签”？

答：先问自己写的是 environment provenance taxonomy，还是 session-side `source` field。

### 问：我是不是把 `179` 又写回 env truth / bridge continuity？

答：先分 repo declaration / branch projection，再考虑它和 env / source 的距离。
