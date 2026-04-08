# 180-190 teleport、model 与 bridge branch map 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/219-teleport、model 与 bridge 分支：为什么 180-190 不是线性十一连.md`
- `05-控制面深挖/180-validateSessionRepository、getBranchFromSession、checkOutTeleportedSessionBranch 与 teleportToRemote：为什么 repo admission 与 branch replay 不是同一种 teleport contract.md`
- `05-控制面深挖/181-createBridgeSession.events、initialMessages、previouslyFlushedUUIDs 与 writeBatch：为什么 session-create events 不是 remote-control 历史回放机制.md`
- `05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger.md`
- `05-控制面深挖/183-initialMessageUUIDs、previouslyFlushedUUIDs、createBridgeSession.events 与 writeBatch：为什么注释里的 session creation events 不等于 bridge 的真实历史账.md`
- `05-控制面深挖/184-getUserSpecifiedModelSetting、settings.model、getMainLoopModelOverride、currentAgentDefinition 与 restoreAgentFromSession：为什么 persisted model preference、live override 与 resumed-agent fallback 不是同一种 model authority.md`
- `05-控制面深挖/185-getUserSpecifiedModelSetting、ANTHROPIC_MODEL、settings.model、mainThreadAgentDefinition.model 与 setMainLoopModelOverride：为什么ambient env preference、saved setting、agent bootstrap 与 live launch override 不是同一种 model source.md`
- `05-控制面深挖/186-initialHistoryCap、isEligibleBridgeMessage、toSDKMessages 与 local_command：为什么 bridge 的 eligible history replay 不是 model prompt authority.md`
- `05-控制面深挖/187-getUserSpecifiedModelSetting、isModelAllowed、ANTHROPIC_MODEL、settings.model 与 getMainLoopModel：为什么 source selection 之后的 allowlist veto 不会回退到更低优先级来源.md`
- `05-控制面深挖/188-model.tsx、validateModel、getModelOptions 与 getUserSpecifiedModelSetting：为什么显式拒绝、选项隐藏与 silent veto 不是同一种 allowlist contract.md`
- `05-控制面深挖/189-reusedPriorSession、previouslyFlushedUUIDs、createCodeSession 与 flushHistory：为什么 v1 continuity ledger 与 v2 fresh-session replay 不是同一种 history contract.md`
- `05-控制面深挖/190-writeMessages、writeSdkMessages、initialMessageUUIDs、recentPostedUUIDs 与 flushGate：为什么 REPL path 与 daemon path 不是同一种 bridge write contract.md`

边界先说清：

- 这页不是 `180-190` 的细节证明总集。
- 这页不替代 219 的结构长文。
- 这页只抓 `178 -> 179 -> 180` 的 teleport runtime、model line里的 `182` 与 `184 -> 185 -> 187 -> 188` 两个 trunk，以及 `176 -> 181 -> 183 -> 186 -> 189 -> 190` 的 bridge line。
- 这页保护的是 teleport runtime、model、bridge birth/hydrate/write 的主语切换，不把某个 helper、某个字段或某个 UUID 集合直接升级成稳定公共合同。
- 这页承接 `205` 的三个出口：`179 -> 180`、`178 -> model line`、`176 -> bridge line`；因此 `205 -> 206` 就是 `168-190` 的接力关系，不需要第三张 `168-190` 伞形总页。
- 如果接下来只想继续深读 model，也仍然留在这张 `180-190` branch map 下，不额外新建 model-only 范围页，更不把 `183/186` 误判成 model 线的缺口。

## 1. 结构总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 219 | 解释 `180-190` 的三条后继线 | 结构收束页 |
| 180 | 继续把 git declaration / branch projection 推到 teleport runtime | teleport runtime zoom |
| 182 | 从 `session_context.model` 打开 model ledger trunk | model-ledger trunk |
| 184 | 继续分 persisted preference / live override / fallback 的主权顺序 | model-resolution trunk root |
| 185 | 再分 ambient env / saved setting / agent bootstrap / live launch override | upstream source-family zoom |
| 187 | 再分 source selection 之后的 source-blind allowlist admission | downstream allowlist-stage zoom |
| 188 | 再分 explicit rejection / write validator / option hiding / silent veto | allowlist-surface zoom |
| 181 | 从 createSession 区域打开 session birth vs history hydrate | bridge birth/hydrate 根页 |
| 183 | 继续分 local dedup seed 与 real delivery ledger | initial-ledger zoom |
| 186 | 继续分 eligible replay projection 与 model prompt authority | replay-object zoom |
| 189 | 再分 v1 continuity ledger 与 v2 fresh-session replay | continuity-contract zoom |
| 190 | 再分 REPL path 与 daemon path 的 bridge write contract | write-contract zoom |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `180-190` 顺着编号就是一条 teleport->model->bridge 的线性十一连 | 更稳的是 teleport、model、bridge 三条后继线 |
| `180` 只是 `181` 的起手例子 | `180` 接 `179` 的 git-context 线；`181` 接 createSession birth/hydrate 线 |
| `182 -> 184 -> 185 -> 187 -> 188` 是一条必须线性下钻的 model 五连 | 更稳的是 `182` = ledger trunk；`184 -> 185 -> 187 -> 188` = resolution/source/allowlist trunk |
| `181/183/186/189/190` 都只是在讲 dedup | 更稳的是 birth/hydrate -> ledger -> replay object -> continuity -> write contract |
| `189` 与 `190` 只是 183 的两个并列尾页 | `189` 先问 continuity inheritance，`190` 再问 REPL/daemon write contract |
| `createBridgeSession.events`、`initialMessageUUIDs`、`previouslyFlushedUUIDs` 只是在同一张历史账里取不同视角 | 它们分属 wire slot、local seed、success ledger、continuity ledger 等不同对象层 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `180` = teleport runtime zoom；model line 里更稳的是 saved preference vs live override 的层次、显式拒绝 / 写入校验 / 选项隐藏且保留 `Default` 的用户 surface，以及 bridge line = `181 -> 183 -> 186 -> 189 -> 190` |
| 条件公开 | 显式 `environmentId` teleport path、`outcomes: []`、`ANTHROPIC_MODEL` / agent bootstrap / allowlist veto、v1 continuity 继承与 v2 fresh-session replay |
| 内部/灰度层 | `session_context.model`、`metadata.model`、`lastModelUsage`、override slot 的具体存储形状、branch naming、history cap 数值、`previouslyFlushedUUIDs` reconnect 细节、provider / allowlist 细则、部分 UX surface 的报错文案 |

更稳的 model 落笔纪律：

- 优先写 `/model`、`/config` 写入、picker 与 default fallback 这些用户可观察 effect。
- `ANTHROPIC_MODEL`、agent bootstrap、allowlist / policy veto 属于条件公开，不写成默认主线。
- `session_context.model`、`metadata.model`、`lastModelUsage` 与具体 helper / slot 名只保留在内部证据层。

## 4. 六个检查问题

- 我现在写的是 teleport runtime、model，还是 bridge history/write？
- 当前 helper / field 出现在多个页面里，是否只是因为它被不同 runtime 合同复用？
- 我是不是把 `180` 的 admission / replay runtime 合同写回了 `179` 的字段语义？
- 我是不是把 `182/184/185/187/188` 又压回“模型设置细节”，忘了 ledger trunk 与 selection/allowlist trunk 的分层？
- 我是不是把 source family、override sink 与 startup snapshot 写成了同一种 source？
- 我是不是把 `181/183/186/189/190` 又压回 generic dedup，而没有先分 birth/hydrate、replay object、continuity 与 write contract？
- 我有没有因为几个页面都出现 `writeBatch(...)` / `model` / `events`，就把它们写成同一条后继线？

## 5. 源码锚点

- `claude-code-source-code/src/utils/teleport.tsx`
- `claude-code-source-code/src/utils/teleport/api.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts`
- `claude-code-source-code/src/utils/model/model.ts`
- `claude-code-source-code/src/utils/model/modelAllowlist.ts`
- `claude-code-source-code/src/utils/model/modelOptions.ts`
- `claude-code-source-code/src/utils/model/validateModel.ts`
- `claude-code-source-code/src/state/onChangeAppState.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/utils/messages/mappers.ts`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
