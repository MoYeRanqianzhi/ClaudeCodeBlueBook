# Remote Control、Trusted Device 与高安全会话

## 1. 先说结论

如果说普通 CLI 会话主要受本地权限系统约束，那么 Remote Control / bridge 则引入了更强的账号级、设备级和基础设施级约束。

它至少额外增加了：

1. 订阅要求。
2. workspace trust 前置要求。
3. 组织 policy 对 `allow_remote_control` 的硬控制。
4. trusted device token 参与的 elevated auth。
5. 401/403/404 触发的 fatal 退出与环境不可恢复。

关键证据：

- `claude-code-source-code/src/entrypoints/cli.tsx:132-158`
- `claude-code-source-code/src/bridge/trustedDevice.ts:15-33`
- `claude-code-source-code/src/bridge/bridgeMain.ts:1941-1948`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2055-2075`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2451-2466`

## 2. Remote Control 不是普通功能开关，而是独立能力域

`cli.tsx` 对 `remote-control` 的启动顺序非常严：

1. 先要求有 Claude.ai OAuth token。
2. 再检查 bridge runtime gate。
3. 再检查最小版本。
4. 再加载 `policyLimits`。
5. 如果 `allow_remote_control` 不允许，直接退出。

证据：

- `claude-code-source-code/src/entrypoints/cli.tsx:132-158`

这说明 remote control 是被单独治理的高敏感能力，不是普通工具扩展。

进一步看 `bridgeEnabled.ts`，还可以得到三个更细的判断：

1. Remote Control 明确要求 `claude.ai` 订阅，而不是任意 first-party 或 Console 登录。
2. 如果缺少 `user:profile` 之类的完整组织画像信息，即便 token 本身可推理，也会被视为无法判断资格。
3. 对这类订阅/组织 gating，系统宁可把磁盘缓存中的 `false` 升级成 blocking 检查，也不愿用陈旧的 `false` 误伤用户。

这说明它不是简单的“功能开关”，而是 entitlement gating 和解释性错误信息的组合。

## 3. workspace trust 在这里是硬门槛

Bridge fast-path 绕过了常规 `main.tsx` 初始化，所以 `bridgeMain()` 会主动检查：

- 当前目录是否已经接受过 trust dialog。
- 未接受就直接退出。

证据：

- `claude-code-source-code/src/bridge/bridgeMain.ts:2038-2093`

这意味着远程会话不会因为“从 Web 进来”就绕开本地信任边界。

## 4. multi-session 与 remote environments 都按账号分层开放

Bridge 中有两类很关键的提示：

- `Multi-session Remote Control is not enabled for your account yet.`
- `Remote Control environments are not available for your account.`

证据：

- `claude-code-source-code/src/bridge/bridgeMain.ts:2055-2075`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2451-2466`

这很像服务端把账号分配到不同能力桶：

- 有人能用 remote，但不能用 multi-session。
- 有人甚至没有 remote environments。

所以“被限制”在这里体现为账号对某个远程能力域失去访问权。

## 5. trusted device 是 bridge 风控里最强的设备约束信号

`trustedDevice.ts` 直接写明：

- bridge sessions 在服务端是 `SecurityTier=ELEVATED`。
- CLI 侧和服务端各有一个 gate，可分阶段 rollout。
- trusted device token 通过 `/auth/trusted_devices` 注册。
- token 持久化到 keychain，90 天滚动过期。

证据：

- `claude-code-source-code/src/bridge/trustedDevice.ts:15-33`

这说明远程控制并不满足于“你已经登录”，而是进一步要求“这台设备也被纳入可信设备模型”。

## 6. trusted device 的设计目的不是便利，而是绑定设备身份

`enrollTrustedDevice()` 的行为也很说明问题：

1. gate 未开则跳过。
2. 没有 OAuth token 则跳过。
3. essential-traffic-only 模式下也跳过。
4. 只有 fresh login 后短窗口内才能成功注册。
5. token 写入 secure storage。

证据：

- `claude-code-source-code/src/bridge/trustedDevice.ts:90-209`

尤其关键的是注释里写明：

- 服务端要求 `account_session.created_at < 10min`
- 晚于这个时间再注册会得到 `403 stale_session`

这本质上是在防止“延迟补注册”替代真实登录后的设备绑定流程。

## 7. bridge 对 401/403 的态度比普通 CLI 更硬

在轮询主循环里：

- `BridgeFatalError` 的 401/403 会被当成 fatal。
- fatal 后不再认为 resume 有意义。
- 会话恢复路径被明确跳过。

证据：

- `claude-code-source-code/src/bridge/bridgeMain.ts:1241-1266`
- `claude-code-source-code/src/bridge/bridgeMain.ts:1515-1538`

普通本地 CLI 里 401 可能先尝试 refresh；而 bridge 这种远程高安全链路更倾向于直接终止不一致状态。

同时，`initReplBridge.ts` 和 `useReplBridge.tsx` 还暴露了一个很现实的工程判断：

- 失效 token 会造成跨进程和跨用户的 401 风暴。
- 系统因此加入了 cross-process backoff、连续失败上限和跳过 guaranteed-fail 调用。

这说明桥接风控不仅是“鉴权是否成功”，还要处理认证失败在大规模环境中的放大效应。

## 8. heartbeat 与 auth_failed 进一步说明这是持续验证，不是一次登录

Bridge 心跳逻辑明确区分：

- `ok`
- `auth_failed`
- `fatal`
- `failed`

而 401/403 会进入 `auth_failed` 分支。

证据：

- `claude-code-source-code/src/bridge/bridgeMain.ts:198-267`

这说明 elevated remote session 不是“登录一次长期通行”，而是持续在验证身份与会话有效性。

## 9. 这层和“封号”是什么关系

Remote Control 场景下，用户最容易感知到的“风控/封禁”表现包括：

1. 账号没有 remote environment 资格。
2. 某些 bridge 能力对该账号尚未开放。
3. trusted device 没建立或失效，导致 elevated 路径无法成立。
4. 401/403 导致桥接链路 fatal 退出。

这些限制比普通 CLI 的 token 过期更像真正的平台级能力封控。

## 10. 一句话总结

Remote Control 把 Claude Code 的风控从“本地权限系统”升级成了“账号、组织、设备、环境四者绑定的高安全会话系统”。
