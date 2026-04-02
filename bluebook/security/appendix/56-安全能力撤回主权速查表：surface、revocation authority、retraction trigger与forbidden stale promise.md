# 安全能力撤回主权速查表：surface、revocation authority、retraction trigger与forbidden stale promise

## 1. 这一页服务于什么

这一页服务于 [72-安全能力撤回主权：为什么不是任何层都能撤回已发布入口，必须由authoritative publisher改口](../72-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E6%92%A4%E5%9B%9E%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E8%83%BD%E6%92%A4%E5%9B%9E%E5%B7%B2%E5%8F%91%E5%B8%83%E5%85%A5%E5%8F%A3%EF%BC%8C%E5%BF%85%E9%A1%BB%E7%94%B1authoritative%20publisher%E6%94%B9%E5%8F%A3.md)。

如果 `72` 的长文解释的是：

`为什么能力撤回和能力发布一样都属于主权动作，`

那么这一页只做一件事：

`把不同 surface 的 revocation authority、retraction trigger 与 forbidden stale promise 压成一张撤回矩阵。`

## 2. 能力撤回主权矩阵

| surface | revocation authority | retraction trigger | retraction action | forbidden stale promise | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| REPL 本地命令面 | remote authoritative `slash_commands` publish set | remote init 到达、publish set 收窄 | 只保留 `remoteCommandSet` 与 `REMOTE_SAFE_COMMANDS` | 本地继续保留远端未发布的旧命令 | `REPL.tsx:1379-1384` |
| remote mode 初始命令面 | local remote-safe prefilter | 进入 remote mode | 预先删掉 local-only 命令 | 先把不安全命令显示出来，再等远端撤回 | `main.tsx:3337-3345,3484-3492`、`commands.ts:678-686` |
| stale MCP client | config authority + stale-client exclusion path | config hash 变化、plugin server 移除、旧 config 失效 | 从 client 集合剔除，并同步清 timer / old onclose / cache | 界面藏了但旧 timer、旧 closure、旧 cache 仍继续活着 | `useManageMCPConnections.ts:782-836` |
| project MCP server 可见资格 | project approval authority | status 不再是 `approved`，或 policy filter 不再通过 | 不进入 `approvedProjectServers` / merged configs | 仅因项目配置文件仍存在就继续承诺 server 可连接 | `mcp/utils.ts:351-372`、`mcp/config.ts:1231-1248` |
| channel capability / Enable prompt | allowlist + capability authority | channels 未启用、pluginSource 不再 allowlisted、capability 不再合法 | `delete exp['claude/channel']`，不再向前台暴露 prompt 条件 | dead button 继续存在，暗示用户仍可启用 | `print.ts:1666-1688` |

## 3. 最短判断公式

看到任一已发布入口时，先问四句：

1. 当前是谁有资格撤回它
2. 触发撤回的 authoritative 条件是什么
3. 撤回后需要同步拆掉哪些旧执行链
4. 如果不撤回，系统会继续保留什么 stale promise

## 4. 最常见的五类撤回越权

| 撤回越权 | 会造成什么问题 |
| --- | --- |
| 本地镜像层拒绝服从 authoritative publish set | 让旧入口继续存活，形成发布裂脑 |
| 只隐藏 stale client，不拆 timer / closure / cache | 旧能力以伪形式继续执行 |
| project approval 失效后仍保留 server 入口 | 把申请态误说成已授权态 |
| allowlist 已收回，按钮仍然显示 | 用 dead button 延续错误承诺 |
| 把局部失败当成正式撤回依据 | 形成新的撤回裂脑 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是“能不能隐藏一个入口”，  
而是：

`谁有资格宣布它不再可见，以及谁无权继续替它说话。`
