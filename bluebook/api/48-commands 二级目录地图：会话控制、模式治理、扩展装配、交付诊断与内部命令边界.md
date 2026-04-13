# Commands 二级目录地图：会话控制、模式治理、扩展装配、交付诊断与内部命令边界

这一章回答五个问题：

1. `commands/` 往二级目录拆开后，到底分成了哪些控制面族群。
2. 哪些命令属于正式公开控制面，哪些命令属于 internal-only、feature-gated 或构建时剔除的命令面。
3. `commands.ts` 与各命令目录之间的真正权威关系是什么。
4. 哪些命令目录最容易被误读，从而把产品边界和工程边界混写。
5. 平台设计者该按什么顺序阅读 `commands/`。

## 0. 代表性锚点与证据梯度

代表性源码锚点：

- `claude-code-source-code/src/commands.ts:224-340`
- `claude-code-source-code/src/commands/plugin/index.tsx:1-10`
- `claude-code-source-code/src/commands/mcp/mcp.tsx:1-85`
- `claude-code-source-code/src/commands/context/context.tsx:1-120`
- `claude-code-source-code/src/commands/permissions/permissions.tsx:1-120`
- `claude-code-source-code/src/commands/resume/resume.tsx:1-120`

这页不再先靠目录体量解释自己，而是先给一条证据梯度：

1. `INTERNAL_ONLY_COMMANDS`
2. `COMMANDS()`
3. runtime assembly
4. 代表性控制面：`resume / compact / permissions / mcp / plugin`

## 1. 先说结论

`commands/` 不是“一堆 slash 命令”目录，而是 Claude Code 的显式控制平面。

这张源码地图最关键的意义不是：

- 命令有多少

而是：

- 哪些命令代表正式 public control surface，哪些命令只是实验、内部或特定构建目标的命令面

## 2. 真正的权威入口是 `commands.ts`

阅读 `commands/` 最稳的入口不是随机打开某个目录，而是先看：

- `INTERNAL_ONLY_COMMANDS`
- `COMMANDS()`

因为这里统一处理了：

1. 哪些命令在外部构建中会被剔除
2. 哪些命令在运行时按 config / feature gate / user type 动态出现
3. 哪些命令是 local-jsx shell，哪些只是包装真实实现

这意味着：

- 命令目录只是定义层
- 真正的公开边界，要到 `commands.ts` 才能看清

## 3. 会话与状态控制命令

- `contract`：
  - `resume`、`compact`、`session`、`context`
- `registry`：
  - `INTERNAL_ONLY_COMMANDS`、`COMMANDS()`、runtime command assembly
- `当前准入命令面`：
  - 当前被装进公开命令面的 session / context / resume 命令子集
- `consumer subset`：
  - 交互式与非交互式路径、不同 host shell 只拿部分控制投影
- `hotspot kernel`：
  - 把恢复、压缩、导出写成便利命令，最容易把会话控制面写浅
- `mirror gap discipline`：
  - 一旦 continue / compact 看起来像小按钮，先回这些命令 contract / registry 和 `commands.ts`

## 4. 模式与设置治理命令

- `contract`：
  - `permissions`、`plan`、`model`、`config`、`hooks`
- `registry`：
  - command gating、mode assembly、user-type/build registration
- `当前准入命令面`：
  - 当前被准入的治理命令子集
- `consumer subset`：
  - user type、mode 与 build 目标决定部分治理命令是否出现
- `hotspot kernel`：
  - 把治理命令写成设置页入口，会直接抹平对象升级与边界改写
- `mirror gap discipline`：
  - 一旦权限、模型、sandbox 讨论开始退回 UI 控件，先回这些命令 contract / registry

## 5. 扩展与连接装配命令

- `contract`：
  - `mcp`、`plugin`、`remote-env`、`bridge`
- `registry`：
  - runtime command assembly、service bridge registration
- `当前准入命令面`：
  - 当前被准入的 connection / plugin 控制命令子集
- `consumer subset`：
  - desktop、mobile、IDE、安装器与 wrapper 更多只是控制壳层
- `hotspot kernel`：
  - 把命令 shell 误当配置真相，最容易把 services 层 authority 写丢
- `mirror gap discipline`：
  - 一旦外部连接看起来像命令层自己就能宣布边界，先回 `services/mcp`、`services/plugins` 与命令 contract / registry

## 6. 交付、诊断与运营命令

- `contract`：
  - `review`、`security-review`、`doctor`、`cost / stats / usage`
- `registry`：
  - review/diagnostic command registration、runtime assembly
- `当前准入命令面`：
  - 当前被准入的 diagnostic / review 命令子集
- `consumer subset`：
  - 成本、统计、诊断大多是消费者可见投影，不是 budget / review authority 本身
- `hotspot kernel`：
  - 把可见投影误写成底层真相，最容易把质量、预算和诊断边界写坏
- `mirror gap discipline`：
  - 一旦 `usage / cost / doctor` 被当成全部真相，先回对应 runtime plane，而不是继续在命令壳层加说明

## 7. 协作、团队与工作流命令

- `contract`：
  - `agents`、`tasks`、`btw`、`brief.ts`
- `registry`：
  - workflow / task / agent command registration
- `当前准入命令面`：
  - 当前被装进公开命令面的 collaboration 命令子集
- `consumer subset`：
  - branch / tag / files / passes 只覆盖协作工作流的某些外部控制动作
- `hotspot kernel`：
  - 把多 agent / task runtime 退回命令菜单层，最容易写坏协作边界
- `mirror gap discipline`：
  - 一旦 `btw`、`agents`、`tasks` 看起来像快捷命令，先回协作 runtime 与这些命令的 contract / registry

## 8. Internal-Only / Feature-Gated 命令面

这层的关键不是名册，而是边界：

- `contract`：
  - `INTERNAL_ONLY_COMMANDS`
- `registry`：
  - build elimination、feature gate、user-type-gated command registration
- `当前准入命令面`：
  - 当前真正对外公开的命令子集
- `consumer subset`：
  - feature-gated、user-type-gated、external build eliminated 都只是特殊命令子集
- `hotspot kernel`：
  - 把 internal-only 命令误写成公开控制面，是命令地图里最常见的假承诺来源
- `mirror gap discipline`：
  - 一旦“代码里有命令”被误读成“产品支持”，先回 `INTERNAL_ONLY_COMMANDS` 与构建剔除边界

## 9. Commands 的三个目录信号

`commands/` 的形状暴露了三个很强的设计信号：

1. 入口壳层与真实实现分离
2. public / internal / gated surface 分层
3. 命令面负责控制，不负责持有全部底层真相

因此最危险的误读通常是：

1. 把命令目录当成唯一权威真相
2. 把 internal-only 命令当成公开能力
3. 把 UI 壳层当成底层控制平面

## 10. Reject 顺序

更稳的 `commands/` reject 顺序是：

1. 先回 `commands.ts`
2. 再回会话控制与治理命令
3. 再回扩展装配控制面
4. 最后才看诊断运营与协作投影层

## 11. 一句话总结

这页真正值钱的，不是把 `commands/` 二级目录再排成一张更细的地图，而是把 later maintainer 拉回：哪些显式控制动作沿 `contract -> registry -> 当前准入命令面 -> consumer subset -> hotspot kernel -> mirror gap discipline` 被公开承诺、被裁切或被拒收。
