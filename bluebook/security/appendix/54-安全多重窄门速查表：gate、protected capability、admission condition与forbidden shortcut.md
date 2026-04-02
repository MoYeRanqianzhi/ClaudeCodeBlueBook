# 安全多重窄门速查表：gate、protected capability、admission condition与forbidden shortcut

## 1. 这一页服务于什么

这一页服务于 [70-安全多重窄门：为什么Claude Code不是先给全量能力再补权限，而是逐层借出能力](../70-%E5%AE%89%E5%85%A8%E5%A4%9A%E9%87%8D%E7%AA%84%E9%97%A8%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E6%98%AF%E5%85%88%E7%BB%99%E5%85%A8%E9%87%8F%E8%83%BD%E5%8A%9B%E5%86%8D%E8%A1%A5%E6%9D%83%E9%99%90%EF%BC%8C%E8%80%8C%E6%98%AF%E9%80%90%E5%B1%82%E5%80%9F%E5%87%BA%E8%83%BD%E5%8A%9B.md)。

如果 `70` 的长文解释的是：

`为什么能力必须穿过多重窄门才会被借出，`

那么这一页只做一件事：

`把不同 gate 的 protected capability、admission condition 与 forbidden shortcut 压成一张能力借出矩阵。`

## 2. 多重窄门矩阵

| gate | protected capability | admission condition | forbidden shortcut | 为什么不能绕过 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| 环境门 | `--dangerously-skip-permissions` 这类高风险运行模式 | 非 root / sudo，且处于允许的 sandbox / launcher 信任模型 | 以 root 直接跳过权限系统 | 环境本身不合法时，后续 permission flow 没有资格成立 | `setup.ts:400-413,416-420` |
| 内容门 | bypass mode 下的敏感路径编辑与显式 ask rule | rule 允许，且未命中 safety check | 认为 bypass 可以越过 `.git/`、`.claude/`、shell config 等路径保护 | bypass 不是总后门，内容风险仍需独立仲裁 | `permissions.ts:1238-1260` |
| 信任门 | hook 执行面 | workspace trust 已正式接受 | 让任意 hook 在未信任 workspace 时先执行 | hook 可执行任意命令，trust 必须是统一前门 | `hooks.ts:267-280,1992-1999` |
| 决议门 | 单次工具权限裁决 | 本地 UI / bridge / channel / hook / classifier 任一合法路径先赢得 resolve | 多源并发后继续改写已成立裁决 | 多源输入若不 resolve-once，会形成安全裂脑 | `interactiveHandler.ts:43-56,236-315,433-448` |
| 发布门 | bridge remote client 可见命令面 | 命令属于 `prompt` 或显式 bridge-safe allowlist | 先向 remote 发布全量 slash command，再靠运行时报错拦截 | 不该拥有的能力不应先暴露再解释 | `commands.ts:663-676`、`useReplBridge.tsx:311-315` |
| 审批门 | project MCP server 进入有效配置集合 | server status 为 `approved` | 仅因写进项目配置就默认生效 | 配置存在只是申请，不是能力主权 | `mcp/utils.ts:351-372`、`mcp/config.ts:1164-1169` |
| 中继门 | channel server 成为 permission surface | connected + `--channels` allowlist + 两个 capability opt-in + structured event | 把普通文本消息或普通 channel relay 当成权限批准 | 能发消息不等于有资格承载审批能力 | `channelPermissions.ts:4-18,169-193`、`coreSchemas.ts:210-217` |

## 3. 最短判断公式

看到任一能力入口时，先问四句：

1. 这项能力现在由哪一重 gate 在保护
2. 当前 admission condition 是否真的成立
3. 用户最容易误以为可以走的 shortcut 是什么
4. 如果允许这个 shortcut，系统会在哪一层失去主权

## 4. 最常见的七类错误 shortcut

| 错误 shortcut | 会造成什么问题 |
| --- | --- |
| 把 bypass 当总后门 | 让内容风险路径误穿透 |
| 把危险模式放在环境门之前 | 让高权限运行时直接跳过结构约束 |
| 把 trust 下放给每条 hook 自己决定 | 让未来 hook 代码路径出现 RCE 漏口 |
| 让多源审批都能继续改判 | 形成权限裂脑 |
| 先把全量命令发布给 remote | 让远端先看到不该拥有的入口 |
| 让 project MCP server 配了就生效 | 把申请入口误当正式授权 |
| 把 channel 文本回复当审批结果 | 让无 capability / 无 allowlist 的中继面越权 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是门很多，  
而是：

`每一重门都只保护自己那一层的能力借出，不允许更后面的门替前面的门补票。`
