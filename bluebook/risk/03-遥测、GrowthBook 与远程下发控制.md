# 遥测、GrowthBook 与远程下发控制

## 1. 先说结论

如果只研究本地权限系统，会低估 Claude Code 风控的真正重心。

更关键的一层是：

1. 用户与设备被建模成可持续识别的实体。
2. 这些实体被送入 GrowthBook、1P event logging、OTel/BigQuery 等观测与实验系统。
3. 远程 managed settings 与 policy limits 再把新的限制反向下发给客户端。

这意味着风控本质上是一个“观测 -> 判断 -> 下发 -> 执行”的闭环，而不是一次性本地校验。

关键证据：

- `claude-code-source-code/src/utils/user.ts:31-47`
- `claude-code-source-code/src/utils/user.ts:78-135`
- `claude-code-source-code/src/utils/telemetryAttributes.ts:29-70`
- `claude-code-source-code/src/services/analytics/growthbook.ts:28-47`
- `claude-code-source-code/src/entrypoints/init.ts:90-122`

## 2. 用户画像不是匿名开关，而是可运算属性集合

`getCoreUserData()` 会把以下内容拼成统一用户画像：

- `deviceId`
- `sessionId`
- `organizationUuid`
- `accountUuid`
- `subscriptionType`
- `rateLimitTier`
- `firstTokenTime`
- GitHub Actions 元数据

证据：

- `claude-code-source-code/src/utils/user.ts:34-47`
- `claude-code-source-code/src/utils/user.ts:78-127`

而 `getUserForGrowthBook()` 直接把这组数据作为 GrowthBook targeting 输入。

证据：

- `claude-code-source-code/src/utils/user.ts:131-135`
- `claude-code-source-code/src/services/analytics/growthbook.ts:32-47`

这说明 feature gate 的目标并不是“某个模糊用户”，而是“设备、账号、组织、订阅、使用阶段”组成的具体实体。

## 3. 遥测属性里直接带账号与组织信息

`getTelemetryAttributes()` 会写入：

- `user.id`
- `session.id`
- `organization.id`
- `user.email`
- `user.account_uuid`
- `user.account_id`

证据：

- `claude-code-source-code/src/utils/telemetryAttributes.ts:29-70`

这类属性意味着：

- 遥测不是纯粹无状态性能指标。
- 账号、组织和会话可以直接成为分析与策略回流的 join key。

## 4. 初始化顺序本身就在为“闭环控制”服务

`init.ts` 在启动早期就做了几件很关键的事：

1. 初始化 1P event logging。
2. 异步填充 OAuth account info。
3. 初始化 remote managed settings 的 loading promise。
4. 初始化 policy limits 的 loading promise。

证据：

- `claude-code-source-code/src/entrypoints/init.ts:90-122`

这不是普通初始化顺序，而是在为后续所有 gate 和 telemetry 提前铺路。

## 5. telemetry 会等待远程设置，说明策略优先于观测

`initializeTelemetryAfterTrust()` 明确写道：

- 对 remote-managed-settings eligible 用户，会先等远程设置加载。
- 然后重新应用 env vars。
- 再初始化 telemetry。

证据：

- `claude-code-source-code/src/entrypoints/init.ts:241-268`

这点很重要：  
Claude Code 不是先盲目启遥测，再看策略，而是允许远程策略先改写遥测初始化条件。

## 6. remote managed settings 是强治理通道

`remoteManagedSettings` 的设计和 `policyLimits` 极像：

- 拉取服务端配置
- checksum / ETag 风格缓存
- 后台轮询
- 失败时 graceful degradation

证据：

- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:1-13`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:68-99`
- `claude-code-source-code/src/services/remoteManagedSettings/index.ts:205-257`

更关键的是，它还有单独的安全检查：

- 如果新设置包含危险项且发生变化，就弹阻塞确认框。
- 用户拒绝时直接退出。

证据：

- `claude-code-source-code/src/services/remoteManagedSettings/securityCheck.tsx:15-72`

这说明远程设置不是普通偏好同步，而是治理命令通道。

## 7. policy limits 是更明确的服务端能力裁决面

`policyLimits` 的行为更像“能力禁用表”：

- 404 代表没有限制或该功能域未启用。
- 401/403 归入未授权，且 `skipRetry: true`。
- 有缓存时允许继续使用 stale restrictions。
- 无缓存时大多 `fail open`。

证据：

- `claude-code-source-code/src/services/policyLimits/index.ts:325-384`
- `claude-code-source-code/src/services/policyLimits/index.ts:428-494`
- `claude-code-source-code/src/services/policyLimits/index.ts:505-575`

这类设计说明服务端随时可以通过 restriction map 改写某些 CLI 功能的可见性。

## 8. GrowthBook 负责把“谁看到什么能力”做成运行时控制

`growthbook.ts` 暴露的不是静态 flag，而是一套持续刷新的 runtime gate 体系：

- user attributes 带账号、组织、订阅、rate limit tier、first token time
- 支持初始化与周期刷新
- 支持远程 eval payload
- 支持 auth 变化后重建

证据：

- `claude-code-source-code/src/services/analytics/growthbook.ts:28-47`
- `claude-code-source-code/src/services/analytics/growthbook.ts:91-157`
- `claude-code-source-code/src/services/analytics/growthbook.ts:316-320`

这意味着功能开关既可以服务产品实验，也可以服务差异化风险控制。

## 9. 隐私级别只能减少上报，不能替代服务端治理

`privacyLevel.ts` 允许：

- `no-telemetry`
- `essential-traffic`

证据：

- `claude-code-source-code/src/utils/privacyLevel.ts:1-44`

但这并不等于退出所有治理：

- 远程 managed settings 与 policy limits 仍然属于功能控制平面。
- `policyLimits` 甚至对 `essential-traffic` 下的部分政策专门定义了 deny-on-miss 例外。

证据：

- `claude-code-source-code/src/services/policyLimits/index.ts:497-519`

因此，“少上报”不等于“脱离控制面”。

## 10. 一句话总结

Claude Code 的风控不是靠客户端偷偷猜用户风险，而是靠 GrowthBook、telemetry、managed settings 与 policy limits 组成一个持续收敛的远程控制回路。
