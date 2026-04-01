# 图解：Remote Control、能力门槛与误伤处置流程

## 1. 为什么增加这一章

前面的章节已经把结论讲清楚了，但很多读者仍然会卡在两个问题上：

1. Remote Control / 高安全会话到底是按什么顺序被放行或拒绝的？
2. 用户一旦疑似误伤，应该怎么按层处理，而不是把所有问题都当成“被封号”？

这章用图把这两件事压缩出来。

## 2. Remote Control 能力门槛时序图

```mermaid
sequenceDiagram
    participant U as 用户
    participant CLI as Claude Code CLI
    participant AUTH as 身份/组织信息
    participant GB as GrowthBook
    participant POL as Policy Limits
    participant BR as Bridge/Remote Control

    U->>CLI: 请求 remote-control / bridge
    CLI->>AUTH: 检查是否 claude.ai 订阅
    AUTH-->>CLI: 订阅是否成立
    alt 无订阅
        CLI-->>U: requires claude.ai subscription
    else 有订阅
        CLI->>AUTH: 检查 profile scope / organizationUUID
        AUTH-->>CLI: 组织信息是否完整
        alt 组织画像不完整
            CLI-->>U: re-login / refresh account info
        else 组织画像完整
            CLI->>GB: 检查 entitlement gate
            GB-->>CLI: gate true/false
            alt gate false
                CLI-->>U: not enabled for your account
            else gate true
                CLI->>POL: 检查 allow_remote_control / allow_remote_sessions
                POL-->>CLI: allowed true/false
                alt policy false
                    CLI-->>U: disabled by your organization's policy
                else policy true
                    CLI->>BR: 检查 trust / trusted device / env register
                    BR-->>CLI: success or 401/403/404
                    alt 成功
                        CLI-->>U: 进入高安全远程会话
                    else 失败
                        CLI-->>U: auth_failed / fatal / environments unavailable
                    end
                end
            end
        end
    end
```

### 图解结论

这张图最想强调的不是流程长，而是：

- Remote Control 并不是“登录成功就自然获得”的普通功能。
- 它是订阅、组织画像、entitlement、组织策略、工作区 trust、设备信任和远程环境共同成立后的结果。

## 3. 错误语义分流图

```mermaid
flowchart TD
    A[用户看到不可用/报错] --> B{错误语义是什么?}
    B -->|401| C[优先看身份连续性/过期/刷新失败]
    B -->|403| D[区分 access denied 与 insufficient_scope]
    B -->|not enabled for your account| E[优先看 entitlement/rollout]
    B -->|disabled by organization policy| F[优先看组织治理]
    B -->|needs-auth| G[优先看子系统连接认证]
    B -->|rate limit / out of extra usage| H[优先看计费与消耗]
    B -->|risky action blocked| I[优先看本地执行安全]

    C --> J[不要立刻当成账号封禁]
    D --> J
    E --> J
    F --> J
    G --> J
    H --> J
    I --> J

    J --> K[先冻结变量]
    K --> L[保留时间线、账号、组织、设备、错误信息]
    L --> M{按哪一层处理?}
    M -->|身份层| N[登录/账号支持]
    M -->|资格层| O[套餐/能力开放支持]
    M -->|组织层| P[管理员/IT]
    M -->|本地执行层| Q[本地权限/工作区 trust 排查]
    M -->|高安全远程层| R[Remote Control / bridge / trusted device 支持]
```

### 图解结论

用户最容易犯的错，是在 `B` 这一步没有分清语义，就直接开始反复切换账号、换 token、换 provider。

## 4. 误伤处置最小流程图

```mermaid
flowchart TD
    A[怀疑自己被误伤/像被封了] --> B[停止继续试错]
    B --> C[冻结账号/设备/网络/组织变量]
    C --> D[记录错误时间和现象]
    D --> E[记录当前身份来源与组织]
    E --> F[判断是否涉及 remote-control / MCP / auto mode]
    F --> G[保存支付、套餐、订阅与支持证据]
    G --> H[按身份/资格/组织/执行/高安全层走支持路径]
```

### 图解结论

误伤时最有效的不是“再试一次”，而是：

- 让问题保持可解释
- 让支持团队有材料
- 不让自己把单层问题试成跨层混乱

## 5. 为什么图解层对中国用户尤其重要

高波动跨境网络环境的用户，更容易在一段短时间里同时触发：

- token 失效与刷新不稳定
- 组织画像不完整
- 远程链路不连续
- 高安全会话重建失败

这时如果没有图解层，很容易把所有异常都压成“是不是被封了”。  
而图解层的价值，就是把这种情绪反应重新拆回治理层。

## 6. 一句话总结

把风控做成图之后，最清楚的一点反而不是“它很复杂”，而是“它根本不是单点封号逻辑，而是一连串分层资格与边界检查”。
