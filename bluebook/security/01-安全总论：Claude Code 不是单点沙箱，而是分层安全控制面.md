# 安全总论：Claude Code 不是单点沙箱，而是分层安全控制面

## 1. 先说结论

Claude Code 的安全性不是一个“沙箱开了没有”的问题，  
也不是一个“分类器强不强”的问题。

更准确地说，它是一套至少由六层组成的安全控制面：

1. trust / init 启动信任层
2. permission mode 权限模式层
3. rule / classifier / denial 权限仲裁层
4. managed env / settings source 配置污染防护层
5. hooks / MCP / WebFetch / gateway 外部能力收口层
6. OAuth / bridge / remote entitlement 远程资格层

这六层连在一起，才构成 Claude Code 的真实安全结构。

如果再往下压一层，这六层也不是六道平行防线，而是在给四类扩张持续收费：

1. 谁能扩张运行时权威
2. 谁能扩张动作自由度
3. 谁能扩张上下文与外部世界暴露面
4. 谁能扩张连续性、恢复与高阶资格

## 2. 为什么说“trust 先于能力”

`managedEnv.ts` 和 `setup.ts` 一起说明了一件很关键的事：

- 在 trust 建立前，不是所有 settings.env 都能直接进入 `process.env`
- 只有 user settings、CLI flags、policy settings 这类受信来源的 env 会先被应用
- project settings、local settings 这类位于项目目录内的来源，只能在 safe allowlist 范围内提前生效

其设计动机写得很直接：

- 防止恶意项目通过 project-scoped settings 把 `ANTHROPIC_BASE_URL` 之类危险变量重定向到攻击者控制的服务

这说明系统不是从工具调用时才开始防守，  
而是从启动时就先问：

`当前哪些配置来源值得被信任到足以改变运行时。`

## 3. 为什么说“mode 不是 UX toggle，而是安全边界”

`PermissionMode.ts` 和 `permissionSetup.ts` 表明：

- `default`
- `plan`
- `acceptEdits`
- `bypassPermissions`
- `dontAsk`
- 以及 feature-gated 的 `auto`

并不是一组单纯的界面状态。

它们真正做的是：

- 改写允许、询问和拒绝的默认路径
- 决定危险规则是否需要被剥离
- 决定某些高风险行为能否绕过人工确认

因此 mode 不是体验层小开关，  
而是：

`安全语义的切换器。`

## 4. 为什么说“真正危险的是绕过仲裁，而不是能力存在”

`dangerousPatterns.ts` 和 `permissionSetup.ts` 的组合，揭示了 Claude Code 很成熟的一点：

- 它真正警惕的不是 Bash、PowerShell 或 Agent 这些能力本身
- 它真正警惕的是过宽的 allow rule 让这些能力在 classifier 之前被直接放行

例如：

- `Bash(*)`
- `Bash(python:*)`
- `PowerShell(iex:*)`
- `Agent(*)`

这种规则危险，不是因为它们“功能太强”，  
而是因为它们：

`跳过了中间仲裁层。`

这是一条非常关键的安全哲学：

`系统最怕的不是锋利工具，而是锋利工具失去边界。`

## 5. 为什么说“沙箱只是其中一层，不是全部安全”

`setup.ts` 明确限制：

- `--dangerously-skip-permissions` 不能在 root / sudo 环境下随意开启
- 即使允许 bypass，也要求在 Docker / sandbox 且无互联网的环境里才成立

这说明系统并没有把 bypass 视为“用户自己承担风险即可”的简单开关。  
它依然要求：

- 环境必须足够可控
- 外部泄露面必须被压低

所以沙箱在这里扮演的是：

- 给高风险模式提供外部边界

但真正的安全设计仍然包括：

- 权限模式
- 规则系统
- 配置来源过滤
- 远程资格收口

## 6. 为什么说“受管环境过滤”是这套系统最容易被低估的能力

`managedEnv.ts` 揭示了 Claude Code 的一个高级安全点：

- 不同 settings source 的 env 权限不同
- host 可以声明由自己管理 provider-routing env
- SSH 隧道场景下，一些 auth 相关 env 会被主动剥离，避免远端配置把本地主机的认证代理语义破坏掉
- CCD 场景还会记录 host 启动时的 env key，防止 settings.env 覆盖桌面宿主的运行时关键变量

这说明 Claude Code 不是把 `process.env` 当作一个平面键值表，  
而是把它当作：

`多来源、多信任等级、需要防污染的运行时控制面。`

## 7. 为什么说“外部能力都被单独收口”

源码已经能看到三种很有代表性的收口：

### 7.1 MCP 收口

`mcpValidation.ts` 会限制 MCP 输出规模，避免外部工具输出无限膨胀。  
这是一种典型的：

- 上下文注入面控制
- 资源消耗控制

### 7.2 WebFetch 收口

`WebFetchTool/preapproved.ts` 明确把：

- WebFetch 的预批准域名
- sandbox 网络权限

刻意分离。

其理由也写得很清楚：

- 某些看似“代码相关”的域名也允许上传
- 允许 GET 不代表应允许任意 POST、上传和数据外流

这是一条非常成熟的安全原则：

`同一目标域的读取语义和写入语义必须分开治理。`

### 7.3 hooks 收口

`hooksConfigSnapshot.ts` 说明：

- managed settings 可以要求只允许 managed hooks
- managed settings 也可以彻底禁用 hooks
- 非 managed settings 不能反向禁掉 managed hooks

这本质上是在解决：

`扩展能力到底归用户、项目还是管理员主权。`

## 8. 为什么说“高阶远程能力最难被兼容入口替代”

`auth.ts`、`bridgeEnabled.ts` 和之前风控专题里的 host/provider 代码一起说明：

- API 请求能成功，不代表第一方 Anthropic auth 仍然开启
- 外部 `ANTHROPIC_AUTH_TOKEN`、`apiKeyHelper`、第三方 provider 与 claude.ai OAuth 不是同一语义
- Remote Control 需要的不是“某种 token”，而是 claude.ai subscription 和 OAuth entitlement

这意味着系统最关键的高阶安全边界之一是：

`谁有资格代表第一方身份面行使高阶能力。`

这也是为什么兼容入口往往只能替代传输层和部分工作流层，  
却很难自动替代完整第一方资格层。

## 9. 从技术角度看，这套安全控制面的先进性在哪里

它至少有四点成熟之处：

1. 安全不是后置补丁，而是前置在启动、模式、规则和远程资格里的 runtime 结构
2. 它明确区分配置来源的信任等级，而不是默认相信项目目录
3. 它不是简单“能力越少越安全”，而是让强能力在仲裁层之后流动
4. 它把外部能力当作独立攻击面分别收口，而不是把所有扩展都放进一个大黑盒

## 10. 从第一性原理看，这套系统究竟在解决什么

如果 agent 要真正进入开发环境，  
安全问题的本质不是“禁止行动”，  
而是四个更底层的问题：

1. 谁能影响运行时
2. 谁能批准高风险动作
3. 谁能把外部世界带进上下文
4. 谁能把宿主身份扩展到远程能力

Claude Code 的答案不是一句 prompt，  
而是一组层层收口的结构。

## 11. 一句话总结

Claude Code 的安全性不是单点沙箱，也不是单点分类器，而是一张由 trust、mode、rule、managed env、外部能力收口和远程资格共同组成的分层安全控制面；它真正先进的地方，不是“更严格”，而是“更会给权威、动作、上下文与连续性扩张定价”。
