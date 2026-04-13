# 源码目录级能力地图：commands、tools、services、状态与宿主平面

> Evidence mode
> - 当前 worktree 若仍缺 `claude-code-source-code/` 镜像，本页所有 `src/...` 路径都只按 archival anchors 读取。
> - 除非 `guides/102` 已先锁定 `promotion-passed` 结果，否则下面的命令、工具、服务、状态与宿主面都只按 `claim-state / provisional claim / consumer subset / gap note` 读取，不偷升成 live runtime certainty。

这页只负责一件事：把目录级能力地图固定到同一条源码质量 canonical ladder。

若问题还停在 `public artifact ceiling / promotion / unresolved-authority`，先回 `guides/102`；若问题已经进入 `one writable present / sole writer / writeback seam / local veto`，统一回 `../architecture/README.md`。本页不重开 frontdoor，只固定下面这六个 rung：

1. `contract`
2. `registry`
3. `current-truth claim state`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

如果这条顺序没有先站稳，任何“命令很多、工具很多、目录很多”的感觉都会把 later maintainer 带回目录体感，而不是源码真相。

## 0. 第一性原理

Claude Code 的目录先进性，首先不是：

- 分类更细
- 文件更多
- 模块名更整齐

而是：

- 它把“系统承认什么”“当前真的装配了什么”“谁有权写现在”“谁只拿到当前可见子集”“哪些复杂度必须合法集中”“哪些结论只配停在镜像缺口说明层”分开写了

因此目录级地图真正要回答的，不是“有哪些目录”，而是：

1. 哪些文件在定义 contract。
2. 哪些文件在列 registry。
3. 哪些 surface 在宣布 now。
4. 哪些 consumer 只拿到 subset。
5. 哪些热点是合法复杂度中心。
6. 哪些地方只能在 mirror gap discipline 下谈结论。

## 1. 六步读法

### 1.1 `contract`

`contract` 先回答：

- 系统正式承认哪些对象、动作、消息与配置可以存在

代表性入口：

1. `src/types/command.ts`
2. `src/Tool.ts`
3. `src/query/config.ts`
4. `src/query/deps.ts`

这层不等于“当前 build 真启用了什么”，它只是可能世界的合法边界。

### 1.2 `registry`

`registry` 再回答：

- 当前 runtime 真的装配了哪些对象

代表性入口：

1. `src/commands.ts`
2. `src/tools.ts`
3. 服务与接入层的装配入口

这层不等于当前真相面。它回答的是存在面和装配面，不回答谁现在有写权。

### 1.3 `current-truth claim state`

`current-truth claim state` 再回答：

- 哪些公开入口已经足够支持“谁在宣布现在、谁在写回 now”的 claim
- 哪些入口在公开镜像里还只配停在 `provisional current-truth claim`

代表性入口：

1. `src/utils/QueryGuard.ts`
2. `src/state/onChangeAppState.ts`
3. `src/services/api/sessionIngress.ts`
4. `src/cli/structuredIO.ts`

这层在源码质量 owner 页上只判断“哪些入口已经足够支撑 `current-truth claim`、哪些仍只配停在 `provisional current-truth claim`”。若还要继续追 `one writable present`、`sole writer`、`writeback seam` 或 `freshness guard`，统一回 `../architecture/README.md`；本页只保留 `claim-state / provisional claim / unresolved-authority note` 的强度，不代签对象层 verdict。

### 1.4 `consumer subset`

`consumer subset` 再回答：

- 同一权威真相对 REPL、headless、bridge、SDK、CI、reviewer 分别暴露了哪一层子集

代表性信号：

1. command visible set
2. tool deny rules
3. simple mode / REPL mode 裁切
4. plugin / skill / workflow / MCP 动态装配

“代码里有”从来不等于“所有入口都承诺有”。

### 1.5 `hotspot kernel`

`hotspot kernel` 最后才回答：

- 哪些大文件和集中点是在合法收口不变量，而不是架构落后

代表性热点：

1. `src/query.ts`
2. `src/utils/task/framework.ts`
3. `src/state/onChangeAppState.ts`
4. `src/cli/structuredIO.ts`

这里真正值钱的不是“文件大”，而是：

- 它们在保护统一不变量、写回顺序、fail-closed 语义与 continuation 定价

### 1.6 `mirror gap discipline`

`mirror gap discipline` 最后约束结论强度：

- 公开镜像、本地扫描、stub/build 脚本、数量统计，都只能帮助定位，不该越位成当前真相

因此目录图里的数量与平面，只能作为：

- mirror hint

不能直接升级成：

- product promise
- runtime truth

## 2. 把 `commands / tools / services / state` 挂回这条梯度

### 2.1 `commands/`

`commands/` 最稳的读法不是 slash 外壳，而是沿同一条六格把命令如何存在、如何装配、当前只够 claim 到哪、哪些入口只拿子集、复杂度集中在哪、何时必须降格写清：

1. `contract`
   - 命令对象的合法形状与显式控制面边界
2. `registry`
   - `COMMANDS()`、`getCommands()` 与动态来源共同组成当前命令装配面
3. `current-truth claim state`
   - 本页只把 runtime assembly 后的 public command surface 记成 `claim-state`；“代码里有命令”不等于“当前公开命令面已经成立”
4. `consumer subset`
   - builtin、skills、plugins、workflows、dynamic skills 只在特定 runtime 成为当前可见集
5. `hotspot kernel`
   - 来源优先级、visible-set discipline 与 reject path 的集中收口
6. `mirror gap discipline`
   - 若要继续按命令二级目录展开，回 `48`；若要继续拆 visible / callable，回 `29`

### 2.2 `tools/`

`tools/` 最稳的读法不是函数集合，而是沿同一条六格把工具如何定义、如何装配、当前只够 claim 到哪、哪些 consumer 只拿子集、复杂度集中在哪、何时必须降格写清：

1. `contract`
   - `Tool.ts` 定义动作 ABI
2. `registry`
   - `getAllBaseTools()`、`getTools()`、`assembleToolPool()` 共同定义当前工具池装配面
3. `current-truth claim state`
   - 本页只把 assembled tool pool 记成 `claim-state`；visible catalog、callable set 与 deferred exposure 仍不能写成同一个对象事实
4. `consumer subset`
   - builtin、MCP、internal、mode-specific tools 只是不同可见子集
5. `hotspot kernel`
   - deny rule、去重、排序、fail-closed 与 caching discipline 的集中收口
6. `mirror gap discipline`
   - 若要继续按工具二级目录展开，回 `47`；若要继续拆 visible / callable / deferred，回 `29`

### 2.3 `services/`

`services/` 最稳的读法不是后台杂项目录，而是沿同一条六格把子系统如何定义、如何装配、哪些面只够支撑 claim-state、哪些 consumer 只拿子集、复杂度集中在哪、何时必须降格写清：

1. `contract`
   - continuation、memory、policy、remote 接入等长生命周期子系统各自的 ingress / runtime contract
2. `registry`
   - `api`、`compact`、`SessionMemory`、`mcp`、`remoteManagedSettings` 等装配入口
3. `current-truth claim state`
   - 只有 `api/sessionIngress`、state writeback、request ingress 一类 surface 直接参与 `current-truth claim`；其余 service 更多只提供 claim-state 输入，不代签对象层 authority
4. `consumer subset`
   - host、CLI、bridge、review、CI 只消费不同子系统投影
5. `hotspot kernel`
   - stale write、config merge、恢复资产与外部能力治理最容易在这里潜入 current truth
6. `mirror gap discipline`
   - 若要继续按服务二级目录展开，回 `46`；若要继续追对象法则，回 `../architecture/README.md`

### 2.4 `state/`

`state/` 不该再和 `query / task / structuredIO` 混写，因为它最接近的 repo seam 是 `host truth externalization`：

1. `contract`
   - `session_state_changed`、app state、host-facing state snapshot 的对象边界
2. `registry`
   - `sessionState`、`onChangeAppState`、notify / writeback wiring
3. `current-truth claim state`
   - 这是源码树里最接近 host-facing `current-truth claim state` 的目录簇；它足以支撑 claim-state 判断，但不在本页直接升级成 `sole writer / writeback seam`
4. `consumer subset`
   - host、UI、bridge、CI、reviewer 只拿到不同 state projection
5. `hotspot kernel`
   - current-state externalization、writeback ordering 与 stale-state reject 的集中收口
6. `mirror gap discipline`
   - 若要继续追对象层 `writer claim plane / local veto / first retreat layer`，回 `../architecture/README.md`

### 2.5 `utils/task / Task.ts`

`Task.ts` 与 `utils/task/framework.ts` 也不该只当“状态文件旁边的大对象”，因为它们更接近 `task runtime kernel`：

1. `contract`
   - `TaskType`、task object、task event 的对象形状
2. `registry`
   - `getAllTasks()`、task registration、task event wiring
3. `current-truth claim state`
   - task runtime 对象当前只够写成 task claim-state，不在本页直接升级成 landed task authority
4. `consumer subset`
   - host、UI、bridge、CI 只拿到不同 task / progress / notification projection
5. `hotspot kernel`
   - task object truth、stale patch reject、task lifecycle ordering 的集中收口
6. `mirror gap discipline`
   - 若要继续看 task object-level writer / retreat layer，回 `../architecture/README.md`

### 2.6 `query.ts`

`query.ts` 最不该被退回“通用大循环”，因为它更接近 `continuation kernel`：

1. `contract`
   - query loop、tool-use turn、compact / retry / re-entry 的运行时边界
2. `registry`
   - query orchestration、continuation hook-up、retry / compact registration
3. `current-truth claim state`
   - 这里只先支撑 continuation / query-loop 的 claim-state，不代签最终 host truth
4. `consumer subset`
   - model、tool runtime、host、reviewer 只消费不同 loop projection
5. `hotspot kernel`
   - continuation pricing、reactive compact、retry ordering 与 fail-closed loop 的集中收口
6. `mirror gap discipline`
   - 若要继续看 decision window / continuation pricing 的 host-facing claim-state，回 `./52-统一定价治理宿主消费面手册：authority source、decision window、pending action、rollback object与continuation gate.md`

### 2.7 `structuredIO / transport`

`structuredIO` 也不该只被并入 “state + query” 混合簇，因为它更接近 `host transport seam`：

1. `contract`
   - `StructuredIO`、transport message、request / response envelope 的边界
2. `registry`
   - structured transport wiring、host ingress / egress registration
3. `current-truth claim state`
   - 这里只先支撑 transport / host handoff 的 claim-state，不代签 object-level authority
4. `consumer subset`
   - SDK、bridge、CLI、remote host 只拿到不同 transport projection
5. `hotspot kernel`
   - transport order、ask correlation、host writeback / replay boundary 的集中收口
6. `mirror gap discipline`
   - 若要继续看 host-facing claim-state / consumer subset / promise boundary，回 `./README.md`

这四组 seam 都比“作者把几类大文件放在一起”更接近 repo structure；later maintainer 真正该先学会 reject 的，也不是“大文件太大”，而是混合簇有没有遮住 `host truth externalization / task runtime kernel / continuation kernel / host transport seam` 这四种不同的复杂度中心。

## 3. 本地扫描数字该停在哪一层

本地扫描数字有价值，但只能停在 `mirror gap discipline`：

1. `src/` 顶层入口规模
2. `commands/`、`tools/`、`services/` 的目录数量
3. `utils/`、`components/` 的文件体量

这些数字能说明：

- 能力面远不是几个命令和几个工具
- 危险改动面不在单一目录

但它们不能直接说明：

- 哪个 API 对外承诺存在
- 哪个路径才是 current truth
- 哪个热点是否先进

## 4. 三条结构拒收信号

目录级地图更该固定下面这组三联拒收信号：

1. `layout-first drift`
   - 先按目录观感下结论，后补 contract / registry / current truth。
2. `recovery-sovereignty leak`
   - 恢复资产、桥接指针或历史快照开始越权写现在。
3. `surface-gap blur`
   - 把 consumer subset、镜像提示或 build/stub 细节误当 current truth。

## 5. 这页真正想教 later maintainer 什么

later maintainer 最该先学会的，不是“有哪些目录”，而是：

1. 先找到 contract。
2. 再找到 registry。
3. 再判断 current-truth claim state 是否已经够当前页允许的 `claim-state` 强度。
4. 再问自己现在看到的是不是只是 consumer subset。
5. 再判断哪个 hotspot kernel 是合法复杂度中心。
6. 最后再决定哪些结论只能在 mirror gap discipline 下保守表达。

这就是目录级地图真正的先进性：

- 它把 later maintainer 的第一条 reject path 放在了源码真相顺序上，而不是作者讲解上。

## 6. 苏格拉底式追问

在你准备把一张目录图当成结论前，先问自己：

1. 我现在说的是 contract、registry，还是只是目录树名字。
2. 谁在写现在，谁又只是投影。
3. 我看到的是 consumer subset，还是 current truth。
4. 这个热点到底是在合法集中复杂度，还是只是在逃避拆分。
5. 我说的是源码真相，还是镜像提示。

## 7. 一句话总结

源码目录级能力地图真正值钱的，不是把 `commands / tools / services / 状态 / 宿主` 排成几列，而是持续把 later maintainer 拉回 `contract -> registry -> current-truth claim state -> consumer subset -> hotspot kernel -> mirror gap discipline` 这条 canonical ladder。
