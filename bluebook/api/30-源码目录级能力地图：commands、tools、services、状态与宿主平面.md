# 源码目录级能力地图：commands、tools、services、状态与宿主平面

这页不该被读成“目录级能力大全”。

更稳的读法是先过两道入口纪律：

1. `public artifact ceiling`
   - 先分清公开镜像到底签到了什么 contract、哪些只是 operator-governance artifact、哪些还处在 runtime-core 缺口里。
2. 源码真相顺序
   - `contract -> registry -> current-truth claim state -> consumer subset -> hotspot kernel -> mirror gap discipline`

文件名里的 `authoritative surface / adapter subset / hotspot gap discipline` 只保留为兼容检索别名，不再拥有首答权。

更细一点说，这页只认同一条源码质量 canonical ladder：

1. `contract`
2. `registry`
3. `current-truth claim state`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

如果这条顺序没有先站稳，任何“命令很多、工具很多、目录很多”的感觉都会重新把 later maintainer 带回目录体感，而不是源码真相。

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

这层是在公开镜像里判断 `one writable present` 是否已经够 promotion 的证据状态。只要 stale snapshot、event replay 或 UI 投影还能越权写现在，这层就还没有站稳。
若 sole writer、writeback seam 与 freshness guard 还没锁定，在公开镜像里最多只能先把它写成 `provisional current-truth claim`，并同步补一条 unresolved-authority note，不能提前宣布 present truth 已经成立。

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

`commands/` 最稳的读法不是 slash 外壳，而是：

1. `contract`
   - 命令对象的合法形状
2. `registry`
   - `COMMANDS()`、`getCommands()` 与动态来源共同组成当前命令装配面
3. `consumer subset`
   - builtin、skills、plugins、workflows、dynamic skills 只在特定 runtime 成为当前可见集
4. `hotspot kernel`
   - 来源优先级、visible-set discipline 与 reject path 的集中收口

### 2.2 `tools/`

`tools/` 最稳的读法不是函数集合，而是：

1. `contract`
   - `Tool.ts` 定义动作 ABI
2. `registry`
   - `getAllBaseTools()`、`getTools()`、`assembleToolPool()` 共同定义当前工具池真相
3. `consumer subset`
   - builtin、MCP、internal、mode-specific tools 只是不同可见子集
4. `hotspot kernel`
   - deny rule、去重、排序、fail-closed 与 caching discipline 的集中收口

### 2.3 `services/`

`services/` 最稳的读法不是后台杂项目录，而是：

1. continuation、memory、policy、remote 接入等长生命周期子系统
2. 这些子系统自己也有 contract、registry 与 subset
3. 真正危险的不是目录多，而是 stale write、config merge、恢复资产与 host projection 从这里潜入 current truth

### 2.4 `state / Task.ts / query / structuredIO`

这组文件最不该被目录地图边缘化，因为它们更接近：

- current-truth claim state
- hotspot kernel

它们共同保护的，是：

1. task object truth
2. session / host writeback truth
3. continuation pricing truth
4. transport order truth

这也是 later maintainer 最该先学会 reject 的一组文件，而不是最后才顺手扫到的大文件。

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
3. 再判断 current-truth claim state 是否已经够 promotion。
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
