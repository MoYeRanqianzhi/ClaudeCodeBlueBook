# 安全多重窄门：为什么Claude Code不是先给全量能力再补权限，而是逐层借出能力

## 1. 为什么要单独写“安全多重窄门”

前面的安全专题已经反复说明：

1. Claude Code 有权限系统
2. 有 workspace trust
3. 有 bridge / channel / MCP 这些外部入口
4. 有 classifier、rules、hooks 与 mode 切换

但如果只把这些零件并列罗列，  
还不足以回答一个更深的问题：

`这些门为什么不是彼此替代，而是要层层串联？`

换句话说：

`为什么 Claude Code 不是先给出全量能力，再靠最后一个 permission dialog 补救？`

从源码看，  
答案很明确：

`因为它的安全哲学不是“能力先存在，权限再裁剪”，而是“能力本来就只能被逐层借出”。`

所以这一章要回答的是：

`安全多重窄门。`

也就是：

`同一项能力要真正落地，往往必须连续通过环境门、信任门、内容门、决议门与发布门；前一门不过，后一门根本不该接管。`

## 2. 最短结论

Claude Code 在源码里已经把“多重窄门”写成了系统语法：

1. 即便处于 bypass mode，显式 ask rule 与 safety check 仍然 bypass-immune  
   `src/utils/permissions/permissions.ts:1238-1260`
2. `--dangerously-skip-permissions` 也不是万能钥匙，root / 非 sandbox 等环境先把它挡掉  
   `src/setup.ts:400-413`
3. 所有 hooks 在交互模式下统一服从 workspace trust，不允许某条 hook 偷跑  
   `src/utils/hooks.ts:267-280,1992-1999`
4. 交互审批不是单一路径，而是本地 UI、bridge、channel、hook、classifier 并发参与，但只允许单次决议  
   `src/hooks/toolPermission/handlers/interactiveHandler.ts:43-56,236-315,433-448`
5. 远端 client 根本看不到全量命令面，只能看 bridge-safe commands  
   `src/commands.ts:663-670`  
   `src/hooks/useReplBridge.tsx:311-315`
6. project MCP server 默认也不直接发布，只有 approved 才进入配置集合  
   `src/services/mcp/utils.ts:351-353`  
   `src/services/mcp/config.ts:1164-1169`
7. channel permission relay 也不是收到文本就算批准，而是 allowlist + capability opt-in + structured event 三重条件  
   `src/services/mcp/channelPermissions.ts:4-18,169-176`  
   `src/entrypoints/sdk/coreSchemas.ts:210-217`

所以这一章的最短结论是：

`Claude Code 的安全性不是一个大门加很多提示，而是一串互不替代的窄门。`

我把它再压成一句：

`真正被授予的从来不是“全部能力”，而只是穿过当前全部窄门之后剩下的那一小段能力。`

## 3. 源码已经说明：能力是在多层窄门之后才被放行的

## 3.1 bypass 并不凌驾于所有门之上

很多系统一旦打开 bypass / dangerous mode，  
就相当于后续安全判断全部失效。

Claude Code 不是这样。

`src/utils/permissions/permissions.ts:1238-1260` 明确写了两条 bypass-immune 规则：

1. content-specific ask rule 必须被尊重
2. safety check 也必须 prompt

作者甚至直接点名：

`.git/`、`.claude/`、`.vscode/`、shell config

这类路径的安全检查不因为 bypass mode 就失效。

这说明 bypass 在这里并不是：

`越过所有门`

而只是：

`越过其中一部分常规门`

也就是说，  
能力并没有因为 mode 切换就重新变成“无条件可用”。

## 3.2 环境门先于权限门：危险模式也要先过运行时约束

`src/setup.ts:400-413` 更进一步说明：

即便用户显式使用：

`--dangerously-skip-permissions`

系统也会先检查：

1. 是否 root / sudo
2. 是否 sandbox
3. 是否属于允许的运行时模型

不满足就直接退出。

这条规则的技术含义非常强：

`危险模式不是主权来源。`

真正更高的主权来自：

`当前运行环境是否足够受限`

所以环境门在这里排在权限门前面。  
你甚至还没进入 permission flow，  
就先被 runtime legitimacy gate 筛过一次。

## 3.3 workspace trust 是统一信任门，而不是某些 hook 的局部选项

`src/utils/hooks.ts:267-280` 和 `1992-1999` 已经把这件事写得很直接：

1. `ALL hooks require workspace trust`
2. 这是 centralized check
3. 目的是防止当前与未来 hook 提前执行造成 RCE

这说明系统的设计重点不是：

`给每条 hook 自己决定要不要信任`

而是：

`先统一确认工作区主权，再允许任何 hook 进入执行面。`

这就是典型的窄门设计：

`前门不过，后门全部不该开放。`

成熟系统不会把这种判断下放给每个 hook 作者各自实现，  
因为那样安全性就会退化成大量局部习惯。

## 3.4 决议门不是单通道，而是多路竞争后的单一裁决

`src/hooks/toolPermission/handlers/interactiveHandler.ts:43-56` 已经说明：

交互式权限流不是同步单线程弹窗，  
而是：

1. 本地 UI
2. bridge
3. channel relay
4. hook
5. bash classifier

这些路径异步竞争。

但关键不在“多路”，  
而在 `236-315` 与 `433-448` 这两段体现出的设计：

1. 多路可以并发参与
2. 但 `resolve-once` 保证只有 first resolver 生效
3. 后来的路径不能重写已经成立的裁决

这说明 Claude Code 不是把安全理解成：

`多加几个判断就更安全`

而是把它理解成：

`多源输入必须被收敛成唯一裁决，否则会形成安全裂脑。`

多重窄门不是多重结论。  
它的本质是：

`多重筛选，单点放行。`

## 3.5 发布门进一步收窄：远端根本拿不到本地完整能力面

`src/commands.ts:663-670` 给了一个非常有代表性的设计：

bridge inbound 默认不是“全量 slash command 都能调”，  
而是：

1. prompt commands 可放行
2. local commands 要显式 opt-in
3. local-jsx commands 继续 blocked

`src/hooks/useReplBridge.tsx:311-315` 则在系统初始化时进一步落实这件事：

远端拿到的 commands 列表，  
直接就是：

`commands.filter(isBridgeSafeCommand)`

这意味着安全并不是等远端点了某个危险命令后，  
再告诉它：

`对不起，这个不能用`

而是：

`这类能力一开始就不被发布给远端。`

这正是“窄门”比“终点拦截”更先进的地方：

`不该拥有的能力，不应先暴露，再解释。`

## 3.6 MCP 也不是“只要写进配置就算接入”，还要先过审批门

`src/services/mcp/utils.ts:351-353` 先把 project MCP server 状态正式分成：

1. `approved`
2. `rejected`
3. `pending`

`src/services/mcp/config.ts:1164-1169` 则更明确：

只有：

`approved`

的 project server 才会进入最终配置集合。

这说明 MCP 接入不是“配置存在 = 能力成立”，  
而是：

`配置存在 -> 审批通过 -> 才能被发布`

也就是说，  
配置文件不是能力主权本身，  
它只是申请入口。

## 3.7 channel permission relay 再次说明：能发消息不等于能当权限面

`src/services/mcp/channelPermissions.ts:4-18` 说明：

channel permission relay 的批准不是普通文本，
而是：

1. human via channel
2. server 解析特定回复
3. 发出 structured permission event

同文件 `169-176` 又明确写出三重条件：

1. connected
2. 在当前 session 的 channels allowlist 内
3. 声明了明确 capability opt-in

`src/entrypoints/sdk/coreSchemas.ts:210-217` 最后把这条边界写进 schema 说明：

只有 approved allowlist 上的 channel，  
才会暴露相应 experimental capability。

这说明 channel server 的能力并不是：

`能发消息 -> 就自然能审批`

而是：

`能发消息 + 被 allowlist 允许 + 明确 opt-in capability + 发出结构化事件`

缺任何一项，  
它都不配成为 permission surface。

## 4. 第一性原理：能力不是被拥有的，而是被借出的

如果从第一性原理追问：

`为什么系统要把能力拆成这么多门？`

因为安全系统真正要管理的，  
从来不是“有没有一个大写的 Allow”，  
而是：

`谁在什么边界内被暂时借出了哪一段能力。`

于是就会自然得到四条第一性原则：

1. 环境不合法，能力不该进入权限流
2. 信任未成立，自动执行面不该开放
3. 内容风险未消除，bypass 也不该穿透
4. 远端或扩展若未被正式发布能力，就不该先看到对应入口

所以多重窄门的第一性原理可以压成一句话：

`capability is leased, not owned.`

也就是说，  
能力不是默认归属某个主体，  
而是系统在每一层证据成立后，  
逐层借出一点点。

## 5. 苏格拉底式自问：为什么不能只靠最后一个权限弹窗

### 5.1 如果最终总会弹窗确认，前面那些门是不是重复了

不是。

因为最终弹窗只能裁决：

`当前这一跳是否允许`

却无法替代：

1. 环境是否合法
2. workspace 是否可信
3. 远端是否本来就不该看到该入口
4. channel / MCP server 是否具备成为权限面的资格

所以前面的门不是重复确认，  
而是在定义：

`哪些对象有资格进入最终裁决面。`

### 5.2 bypass 既然叫 dangerous，为什么不彻底放开

因为“dangerous”不等于“取消结构”。

如果 bypass 真能越过所有门，  
那么它不再是高风险模式，  
而会变成：

`系统架构的总后门。`

Claude Code 明显在避免这一点。

### 5.3 远端 / channel 为什么不能默认继承本地所有能力

因为它们拥有的是：

`不同的交互表面、不同的信任模型、不同的失败模式`

能接消息，  
不代表能安全承载本地 Ink UI；  
能中转文本，  
不代表能成为权限批准面；  
能连上 MCP，  
不代表能自动成为批准过的 project server。

### 5.4 多重窄门会不会让系统显得繁琐

会更克制，  
但不会更混乱。

真正混乱的系统恰恰是那些：

`入口先全开，出问题后再靠例外补丁缝起来`

多重窄门的价值就在于：  
它把“例外”变成前置结构，  
而不是后置事故。

## 6. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性不在于它有很多安全提示，而在于它把能力发布本身做成了分层协议。`

它先进的地方有六点：

1. bypass 不是万能豁免，而是被更高层 safety gate 继续约束
2. workspace trust 被做成所有 hook 的统一前门
3. 多路审批输入被收敛为 resolve-once 的单一裁决
4. bridge remote client 根本拿不到不该用的命令面
5. MCP project server 必须审批后才能进入配置面
6. channel relay 必须 allowlist、opt-in capability 与 structured event 同时成立

对其他 Agent 平台构建者的直接启示有六条：

1. 不要把权限系统设计成唯一安全门
2. 把 capability publish 和 capability use 分成两层
3. 让远端只看到已发布的安全子集，而不是看到全量再报错
4. 让 bypass 受更高层结构约束，避免它变成总后门
5. 让所有外部审批面先过 allowlist 与 capability opt-in
6. 多源审批必须 resolve-once，不能允许并发来源改写同一决议

## 7. 一条硬结论

对 Claude Code 这类系统来说，  
真正成熟的安全不是：

`把最后一个拒绝按钮做得足够醒目。`

而是：

`在那之前，系统已经通过多重窄门把大部分不该存在的能力面提前消失掉了。`

所以这套设计最本质的哲学可以压成一句：

`安全不是最终是否拒绝，而是能力根本是如何被借出的。`
