# 权威面与反僵尸图谱：current-truth surface、current-truth writeback、recovery asset non-sovereignty、freshness gate与ghost capability

这一章回答五个问题：

1. 为什么 Claude Code 的源码先进性最终要回到 current-truth surface，而不是停在模块美学。
2. 为什么 startup 顺序、release shaping、状态写回与恢复资产必须放在同一张结构图上。
3. 为什么 anti-zombie 不是局部并发技巧，而是一类跨系统不变量。
4. 为什么后来维护者最需要的不是更多 helper，而是更清楚的 current-truth surface。
5. 这对 Agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/cli.tsx:16-33`
- `claude-code-source-code/src/entrypoints/init.ts:57-113`
- `claude-code-source-code/src/main.tsx:1903-1980`
- `claude-code-source-code/src/query/config.ts:8-45`
- `claude-code-source-code/src/query/deps.ts:8-40`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-211`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:17-55`
- `claude-code-source-code/src/utils/task/framework.ts:158-269`
- `claude-code-source-code/scripts/build.mjs:5-117`

这些锚点共同说明：

- Claude Code 的源码先进性，不在于仓库“看起来更像教科书”，而在于系统先把 current-truth surface、陈旧写回拒绝、recovery asset non-sovereignty 与发布面边界都写进了结构。

如果把这一章再压成前门顺序，也只该剩：

- `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline`

## 1. 先说结论

Claude Code 更深的一层工程成熟度，可以压成四张图：

1. policy-ordered bootstrap
2. current-truth surface atlas
3. anti-zombie invariant catalog
4. release-surface shaping matrix

这里的“四张图”不是第四条母线，而是源码质量线在不同结构切面与时间轴上的投影。

这四张图一起回答的是同一件事：

- 当前真相怎样不被旧对象、错误入口、陈旧状态与错误发布面重新写坏

它们拆开的不是第四类主语，而是同一条“现在不能被过去写坏”的结构链在 bootstrap、authority、recovery 与 release 上的不同裁面。

更前门地说，这四张图其实在共同保护：

- `current-truth surface -> recovery asset non-sovereignty -> freshness gate -> ghost capability`

更准确地说，这四张图共同复写的是同一条时间轴：谁先定义现在、哪些恢复资产不得篡位、哪些陈旧写入必须先被 freshness / eviction 撤权。

这条线最短的 reject trio 也只认：

1. `layout-first drift`
2. `recovery-sovereignty leak`
3. `surface-gap blur`

## 2. 第一性原理：先问哪里会说谎，再谈哪里分层更好看

很多团队讨论源码先进性时，先问的是：

- 目录够不够整齐
- 文件够不够小

Claude Code 更值得学的一点是：

- 它先问哪里最可能说谎

这会把“好结构”的定义从静态美学改写成：

1. 当前哪条 current-truth surface 负责宣布真相
2. 哪些 alternate writer 明确被禁止
3. 哪些恢复资产只能帮助恢复，不能篡位
4. 哪些 freshness gate / ghost capability 清理条件被正式编码

所以这里的先进性首先是故障模型先进，而不是目录快照先进。

## 3. Policy-Ordered Bootstrap：启动链路先保护边界，再扩系统

`cli.tsx`、`init.ts` 与 `main.tsx` 揭示了同一条成熟纪律：

- 启动不是“先把一切拉起来”，而是“先按边界顺序建立世界”

这条顺序至少包含：

1. fast-path mode split
2. 只允许安全 env/network prep 进入 pre-trust 阶段
3. trust 建立后才打开更危险的子系统
4. parallel loading 也必须服从上述边界

这说明 Claude Code 的启动不是薄壳 CLI，而是：

- policy-ordered bootstrap

也就是说，边界先成立，功能才被陆续授予。

## 4. Current-Truth Surface Atlas：当前谁配写当前真相

Claude Code 的高级点，在于它不断把 current-truth surface 做显式化。

最值得抓的几类 surface 是：

1. `permission_mode`
   - 由 `onChangeAppState.ts` 外化，不允许多个 UI 或 host 自行猜测
2. session metadata
   - 由 `sessionState.ts` 与 host writeback 链维护，不允许历史消息临时重建
3. protocol transcript
   - 由 `messages.ts` 编译，不允许显示层文本直接越权进入 API 面
4. bridge control
   - 由 bridge messaging / enablement surface 统一宣布，不允许 transport 自行改写主语
5. trust / feature boundary
   - 由 entry bootstrap 与 build shaping 共同定义，不允许晚到模块偷偷扩面
6. tool write boundary
   - 由 `validateInput / checkPermissions / call` 与 fresh-read write gate 统一裁决，不允许模型文本越过工具边界直接宣布文件侧真相

这类 current-truth surface 真正保护的不是：

- 入口看起来更清楚

而是：

- 后来者知道谁能写、谁只能读

这里也要再压住一条对象层准入纪律：公开 operator artifact 先只有 `surface candidate`。除非公开证据已经足够说清它的 signer、作用域与第一条 `local veto cue`，否则对象层不该替它预填 `sole writer`；`CLAUDE.md`、hooks、skills、settings 这些 surface 可以先进入 atlas，但不能因为公开可见就自动升级成 current-truth writer。

更稳的 current-truth surface atlas 至少该能被压成下面这张表：

| current-truth object | sole writer | per-host width | forbidden substitute writer | freshness / eviction guard |
|---|---|---|---|---|
| `permission_mode` | `onChangeAppState` | CLI / SDK / external metadata projection | 任意 UI 本地猜测 mode | runtime externalization only |
| `pending_action` | `sessionState + external_metadata` | host-facing status width | transcript replay / tool log prose | stale field cleanup before reuse |
| `worker_status` | `reportState/reportMetadata` | CCR / SDK status width | event timeline / print log | coalesced uploader + flush discipline |
| `bridge pointer vs session head` | server/session head | bridge freshness pointer | pointer 直接宣布 current truth | TTL + head adoption |

按 landing card 语法再压一层，这张表里的 `forbidden substitute writer` 就是各 current-truth object 的第一条 `local veto cue`，而离它最近、能重新取回 sole writer 资格的 `freshness / recovery / eviction` seam，就是 `first retreat layer`。

## 5. Anti-Zombie Pattern Catalog：过去不能把自己写回现在

Claude Code 的 `anti-zombie` 不是一句注释，而是一套跨系统复现的写法纪律。

最重要的模式至少有九种：

1. `generation guard`
   - `QueryGuard` 明确阻止 stale finally 清掉 fresh query
2. `fresh merge before writeback`
   - `task/framework.ts` 不允许旧快照整对象回写 fresh task
3. `409 session-head adoption`
   - `sessionIngress.ts` 遇到冲突先承认 server head，而不是坚持本地旧状态
4. `pointer freshness + TTL`
   - `bridgePointer.ts` 让恢复资产围绕 repo、mtime 与 worktree 继续保鲜
5. `durable coalesced uploader`
   - `WorkerStateUploader.ts` 让状态写回尽量聚合、重试且不制造第二真相
6. `fresh-read write gate`
   - `FileEdit / FileWrite` 要求 staleness check 与落盘之间不能插异步；旧快照一旦过期就必须重新读取
7. `validator-desync downgrade`
   - PowerShell validator 一旦怀疑 cwd 已 stale，就取消 auto-allow，统一退回人工确认
8. `dangerous-delta confirm-or-exit`
   - remote managed settings 获取可以 stale-degrade，但危险增量必须阻塞确认；拒绝后直接退出，不能带着旧判断继续运行
9. `ghost-capability eviction`
   - MCP config、credential 或 plugin 状态一旦变化，就主动清掉 stale tools、resources 与 caches，避免 ghost tools / ghost auth 继续挂在当前世界里

把这五类模式放在一起看，会发现 Claude Code 真正反对的是：

- stale async work
- stale pointer
- stale control traffic
- stale head assumption
- stale file snapshot
- stale validator worldview
- stale capability directory
- stale credential cache

这就是 anti-zombie 之所以是正式结构原则，而不是 race fix 技巧。

## 6. Recovery Asset 不能篡位：帮助恢复，不得宣布真相

`bridgePointer.ts` 与 `sessionIngress.ts` 一起说明：

- recovery asset 很重要，但它不配变成 current-truth surface

更准确地说：

1. pointer 是恢复资产
2. session head 是当前权威
3. pointer 可以帮助你找到 head
4. pointer 不能跳过 head 自己宣布自己最新

这会把恢复设计从：

- 能恢复就算成功

改写成：

- 恢复资产必须帮助回到主权对象，但不能长成第二权威面

同一原则也适用于：

1. remote managed settings cache
   - 可以帮助恢复可用性，但不能带着旧危险判断继续签发当前世界
2. MCP capability cache
   - 可以帮助减轻重连成本，但 config / token / plugin 状态一旦变化就必须主动失效
3. WebFetch preapproved host
   - 可以帮助复用已批准主机，但跨 host redirect 之后必须重新取真相，而不是把旧 host 权限偷渡过去

## 7. Release-Surface Shaping：构建系统也在限制谁能进入公开图谱

`build.mjs`、`bridgeEnabled.ts`、entry shadow 与 compile-time `feature()` 共同说明：

- 发布面不是构建之后自然出现的，而是被源码主动塑形的

更稳的理解方式是把它分成三层：

1. compile-time gate
   - 决定哪些边根本不进入公开图谱
2. runtime gate
   - 决定哪些能力在当前账号、组织、环境下可被点亮
3. artifact surface
   - 决定 public / internal build 最终让谁看见什么

这说明 Claude Code 的工程先进性不只来自运行时，也来自：

- 发布面边界被当成正式结构控制面

## 8. 为什么后来维护者会从这里直接受益

如果一个仓库没有 current-truth surface，也没有 anti-zombie catalog，那么后来维护者面对问题时只能：

- 到处 grep
- 到处猜谁是权威
- 到处担心旧状态什么时候会复活

Claude Code 更成熟的地方，在于它尽量让后来维护者直接得到三条 formal ability：

1. 能快速找到谁说了算
2. 能快速拒绝第二真相
3. 能快速识别哪些旧写法会 zombify present state

这就是为什么“源码先进性”在这里首先服务未来维护者，而不是先服务当前作者自我感觉良好。

如果继续把这件事压成 later maintainer 真正拿得到手的 formal ability，它至少还应继续导出一条最小 reject order：

1. `shim exit condition`
   - 没有退出条件的 shim 先不配进入长期结构。
2. `recovery asset non-sovereignty`
   - snapshot、pointer、cache 一旦能直接宣布 current truth，就先判定越权。
3. `stale authority / ghost capability eviction`
   - 旧 capability token、旧 authority width、旧 display pin 只要仍能放权，就先退回 freshness / eviction 层。
4. `retreat layer`
   - 一旦失真，必须能说清先退 `authority / contract / seam / shell / recovery / eviction` 哪一层。

## 9. 对 Agent Runtime 设计者的直接启发

如果你想复制 Claude Code 的源码成熟度，先别急着复制：

- 更多 layer
- 更多 helper
- 更碎的目录

优先应该复制的是：

1. policy-ordered bootstrap
2. current-truth surface
3. recovery asset non-sovereignty
4. freshness gate / anti-zombie invariant
5. ghost-capability eviction
6. release-surface shaping

如果这六件事不先成立，再漂亮的模块图也只是当前快照更好看。

## 10. 苏格拉底式追问

在你准备宣布“我已经理解了 Claude Code 的源码先进性”前，先问自己：

1. 我找到了 current-truth surface，还是只找到了大文件。
2. 当前真相到底由谁写；有没有 alternate writer 被默认放过。
3. recovery asset 在帮助恢复，还是已经偷偷篡位成第二真相。
4. 我能否明确说出哪些 stale writer 会 zombify present state。
5. build-time gate、runtime gate 与 artifact surface，我有没有混成一层。
6. 如果把作者换掉，未来维护者还能靠结构自己拒绝错误实现吗。
7. 如果今天必须撤回这次结构升级，我知道该先退哪一层，而不是只会说“以后再重构”吗。

## 11. 一句话总结

Claude Code 的源码先进性，首先不是目录更漂亮，而是它把 current-truth surface、recovery asset non-sovereignty、freshness gate、ghost capability 与 release shaping 一起写成了结构真相，先替后来者保住了“现在不能被过去写坏”的权利。
