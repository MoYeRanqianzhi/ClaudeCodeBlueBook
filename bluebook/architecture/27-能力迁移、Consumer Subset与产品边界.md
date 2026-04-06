# 能力迁移、Consumer Subset 与产品边界

这一章回答六个问题：

1. 为什么 Claude Code 的能力边界不能只按“代码里有没有”判断。
2. build-time gate、runtime gate、compat shim、consumer subset 各在解决什么问题。
3. marketplace、plugin manifest、MCPB、LSP、channels 为什么不能被写成同一层成熟度。
4. 为什么一些能力看起来“已经支持”，但产品边界仍然很窄。
5. 这套迁移方法为什么比简单 feature flag 更像产品工程。
6. 研究这些能力边界时，最小判断顺序是什么。

## 1. 先说结论

Claude Code 的能力迁移至少要按四层理解：

1. build-time gate：
   - 某能力是否进入当前产物
2. runtime gate：
   - 当前账号、组织、环境是否真的打开
3. compat shim：
   - 新旧实现如何并存，避免瞬间断裂
4. consumer subset：
   - schema / runtime 全集不等于每个 adapter / UI 都完整消费

这四层共同决定了“某能力在产品上到底算不算存在”。

关键证据：

- `claude-code-source-code/src/entrypoints/cli.tsx:18-26`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts:120-202`
- `claude-code-source-code/src/services/mcp/channelNotification.ts:1-220`
- `claude-code-source-code/src/services/mcp/channelAllowlist.ts:1-67`
- `claude-code-source-code/src/utils/plugins/marketplaceManager.ts:1-169`
- `claude-code-source-code/src/utils/plugins/schemas.ts:1-180`
- `claude-code-source-code/src/utils/plugins/mcpbHandler.ts:1-220`
- `claude-code-source-code/src/services/lsp/manager.ts:1-180`

## 2. build-time gate：先决定哪些能力能出现在当前 build 里

`cli.tsx` 和 `bridgeEnabled.ts` 已经说明：

- 某些路径只有在 `feature('...')` 为真时才会进入当前 build
- 这不是“少一个按钮”，而是让 dead code elimination 真正裁掉实现与字面量

典型例子：

- bridge / remote control
- daemon
- background sessions
- templates
- BYOC / self-hosted runner

因此只要某能力还受 build gate 控制，蓝皮书就不能把它直接写成“无条件公共能力”。

## 3. runtime gate：进入 build 不等于对当前用户开放

即使某能力进入了产物，也还会继续经过：

- GrowthBook gate
- OAuth / subscription check
- managed settings policy
- allowlist / blocklist
- session/runtime 条件

channels 就是最典型的例子：

1. build gate 通过
2. 总 runtime gate `tengu_harbor`
3. OAuth-only
4. team/enterprise 还要 managed settings opt-in
5. 再过 session `--channels`
6. 再过 allowlist

这说明 runtime gate 在 Claude Code 里是多层组合，而不是单一布尔量。

## 4. compat shim：迁移不是切换实现，而是维持连续性

`isCseShimEnabled()` 这类代码最能说明 Claude Code 的迁移方法：

- 新 worker 端先给出新 ID/新语义
- 旧前端和旧 validator 仍依赖老语义
- 中间先放 compat shim
- 等上下游都升级，再关闭 shim

这意味着 Claude Code 更接近：

- 迁移系统

而不是：

- 功能开关系统

## 5. consumer subset：协议全集不等于每个产品面都完整消费

这条原则在宿主、channels、plugin/LSP 里都很明显。

### 5.1 channels

server 可能具备 `claude/channel` capability，但只有通过 allowlist / policy / auth 的那一部分，前台才会真正呈现“Enable channel?”。

### 5.2 LSP

LSP manager 明确有：

- `not-started`
- `pending`
- `success`
- `failed`

而调用方很多时候只关心：

- 有没有可用 server

这就是典型的 consumer subset。

### 5.3 MCPB / marketplace

`ManagePlugins.tsx` 为 MCPB 做了 manifest path、raw marketplace.json fallback、用户配置流等大量兼容处理。
这说明：

- schema 支持
- 安装管理支持
- 前台完整产品体验

不是一层东西。

## 6. marketplace、plugin manifest、MCPB、LSP、channels 不是一个“统一生态成熟度”

这几块都属于扩展边界，但成熟度和职责明显不同：

### 6.1 marketplace

它已经是：

- source intent
- cache
- policy allow/block
- auto-update 默认值
- official-name/source 验证

的正式管理层。

### 6.2 plugin manifest

它解决的是：

- 安装分发
- commands/agents/skills/hooks/mcpServers 的 bundle-level 声明

### 6.3 MCPB

它更像：

- plugin 内嵌 MCP bundle 的额外交付物
- 带用户配置、解包、secure storage、hash/cache 的专门安装流

### 6.4 LSP

它是：

- 编辑器现场与被动诊断的长期连接层
- 初始化状态、重载、插件刷新的一部分

### 6.5 channels

它是：

- MCP server 的一种受强治理通知面
- 需要 capability、auth、org policy、session opt-in、allowlist 多层通过

因此把这五者都写成“插件生态的一部分”会系统性误导读者。

## 7. 从第一性原理看，这套迁移方法在解决什么

Claude Code 同时面对：

- 多种 build 形态
- 多类用户与组织
- 多种 adapter / transport
- 多代实现并存
- 一部分能力明显还在演化中

如果没有：

- build-time elimination
- runtime rollout
- compat shim
- consumer subset

它就只能在“要么全放开、要么全隐藏”之间摇摆。

而现在这套方法允许它做到：

- 逐层放行
- 分面演化
- 保持旧链路不断

## 8. 研究这些能力边界时的最小检查表

只要研究这些边界，必须先问：

1. 这是 build-time 还是 runtime 事实。
2. 这里有没有 compat shim。
3. 谁是当前真正的 consumer。
4. 这条能力链在产品上到底走到哪一步。

如果四问不答，蓝皮书就会把“代码有入口”误写成“产品已成熟”。

## 9. 一句话总结

Claude Code 的能力演化不是开关堆砌，而是一套由 build gate、runtime gate、compat shim 和 consumer subset 共同组成的迁移系统。
