# 安全能力发布主权速查表：surface、authoritative publisher、visible capability与forbidden overclaim

## 1. 这一页服务于什么

这一页服务于 [71-安全能力发布主权：为什么不是任何接入层都能把能力显示成可用入口](../71-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%8F%91%E5%B8%83%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E6%8E%A5%E5%85%A5%E5%B1%82%E9%83%BD%E8%83%BD%E6%8A%8A%E8%83%BD%E5%8A%9B%E6%98%BE%E7%A4%BA%E6%88%90%E5%8F%AF%E7%94%A8%E5%85%A5%E5%8F%A3.md)。

如果 `71` 的长文解释的是：

`为什么入口可见性本身就是安全承诺，`

那么这一页只做一件事：

`把不同 surface 的 authoritative publisher、visible capability 与 forbidden overclaim 压成一张发布主权矩阵。`

## 2. 能力发布主权矩阵

| surface | authoritative publisher | visible capability | publish condition | forbidden overclaim | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| REPL bridge `system/init` 给 remote | bridge 侧经过 redaction 的 `buildSystemInitMessage(...)` 输入 | bridge-safe slash commands；不含 tools / mcpClients / plugins | bridge 明确过滤并决定哪些字段可上行 | 把本地全量 tools、MCP、plugin paths 直接发布给 remote | `useReplBridge.tsx:297-318`、`systemInit.ts:41-53,57-85` |
| remote mode 初始命令面 | local prefilter + remote-safe command set | 仅 `filterCommandsForRemoteMode()` 允许的命令 | 进入 REPL 前就先完成 remote-safe 预过滤 | 让 local-only 命令短暂露出，再靠后续 init 撤回 | `main.tsx:3337-3345,3484-3492`、`commands.ts:678-686` |
| REPL 收到 remote init 后的本地命令表面 | remote authoritative `slash_commands` publish set | `remoteCommandSet` 命中的命令，加本地 `REMOTE_SAFE_COMMANDS` | 远端 init 已正式宣告这组命令 | 本地 adapter 因“猜测可用”继续保留更多命令 | `REPL.tsx:1379-1384` |
| project MCP server 进入有效配置集合 | project server approval gate | 只有 `approvedProjectServers` 可进入 merge / connect path | status = `approved` | 仅因写进项目配置就默认发布成可连接能力 | `mcp/utils.ts:351-372`、`mcp/config.ts:1164-1188,1231-1238` |
| channel capability 字段进入 schema / output | allowlist + capability opt-in gate | `experimental['claude/channel']` 与相关 prompt 触发能力 | plugin 在 approved channels allowlist 中，且 capability 已存在 | 把普通 connected channel 或普通文本中继发布成 permission surface | `coreSchemas.ts:210-217`、`print.ts:1666-1676`、`channelPermissions.ts:169-193` |
| remote command safety 判定 | `isBridgeSafeCommand` / `REMOTE_SAFE_COMMANDS` | prompt commands + explicit safe allowlist | 类型或 allowlist 显式通过 | 让 local-jsx / 未批准 local command 被当成 remote 可用入口 | `commands.ts:662-676` |

## 3. 最短判断公式

看到任一“可用入口”时，先问四句：

1. 这项能力是谁发布出来的
2. 发布它的那一层，是否真的掌握对应 gate 的结果
3. 当前可见入口是在陈述事实，还是在越权作承诺
4. 如果这层 overclaim，用户会被引向哪条错误心智模型

## 4. 最常见的六类发布越权

| 发布越权 | 会造成什么问题 |
| --- | --- |
| bridge 把全量本地能力原样上行 | 泄露 integration / path，并制造 remote 过度能力承诺 |
| remote 模式先显示 local-only 命令 | 形成短暂但真实的错误入口承诺 |
| adapter 忽略 authoritative remote slash set | 让本地表面比远端正式发布集说得更满 |
| project config 一写即生效 | 把申请入口误说成已授权能力 |
| allowlist 外 channel 仍显示 enable prompt | 把未批准中继面误包装成可启用能力 |
| capability 字段无条件透出 | 让“存在于底层”被误读成“可由此前台合法承载” |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是“入口最终能不能点通”，  
而是：

`哪一层有资格把它先显示出来。`
