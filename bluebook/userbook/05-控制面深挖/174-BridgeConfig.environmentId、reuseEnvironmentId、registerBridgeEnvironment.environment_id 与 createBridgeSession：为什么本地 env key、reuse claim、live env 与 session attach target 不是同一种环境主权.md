# `BridgeConfig.environmentId`、`reuseEnvironmentId`、`registerBridgeEnvironment.environment_id` 与 `createBridgeSession`：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权

## 用户目标

173 已经把 environment truth layering 拆成：

- pointer 里的 env hint
- server session env
- registered env result

但如果正文停在这里，读者还是很容易把 register 这条链内部再写平：

- `BridgeConfig.environmentId` 不也是环境 ID 吗？
- `reuseEnvironmentId` 不也是环境 ID 吗？
- 注册返回的 `environment_id` 不也是环境 ID 吗？
- 后面 `createBridgeSession({ environmentId })` 不也还是把同一个环境传下去吗？

这句还不稳。

从当前源码看，standalone / REPL bridge 的 register chain 至少还分成四种不同的 environment authority：

1. local config key
2. backend reuse claim
3. live registered env
4. session attach target

如果这四层不先拆开，后面就会把：

- `BridgeConfig.environmentId`
- `reuseEnvironmentId`
- `registerBridgeEnvironment(...).environment_id`
- `createBridgeSession({ environmentId })`

重新压成同一种“当前环境 ID”。

## 第一性原理

更稳的提问不是：

- “这些字段是不是都只是环境 ID 在不同阶段的名字？”

而是先问五个更底层的问题：

1. 当前字段服务的是本地配置对象、re-register 请求、后端当前结果，还是后续 session attach？
2. 当前字段是 client-generated、本地暂存的，还是 backend-issued、可被服务器承认的？
3. 当前字段如果和后端结果不一致，系统会保留它、发送它，还是直接放弃它？
4. 当前字段进入的是 `/v1/environments/bridge` 注册面，还是后续 `/v1/sessions` attach 面？
5. 如果来源、消费 API、被拒绝后的政策都不同，为什么还要把它们写成同一种环境主权？

只要这五轴不先拆开，后面就会把：

- local config slot
- reuse request
- live environment
- session attach target

混成一句模糊的“环境继续被复用了”。

## 第一层：`BridgeConfig.environmentId` 先是 local config key，不等于后端承认的 env

`types.ts` 对 `BridgeConfig.environmentId` 的注释写得很硬：

- client-generated UUID for idempotent environment registration

同时，standalone `bridgeMain.ts` 和 headless bridge 初始化都会先把它设成：

- `environmentId: randomUUID()`

这说明它首先回答的问题不是：

- 当前 live environment 是谁

而是：

- 当前本地 bridge config 对象里，先占一个环境身份槽位

更关键的一点是：

- `bridgeApi.ts` 的 `registerBridgeEnvironment(...)` request body 并不会直接发送 `config.environmentId`
- 它真正条件性发送的 env 字段只有 `config.reuseEnvironmentId`

所以更准确的理解不是：

- `BridgeConfig.environmentId` 已经在注册面里拥有高主权

而是：

- 它先是 local config key
- 在当前 register path 里并不自动升级成后端承认的 environment claim

因此它的厚度更像：

- local config key

不是：

- backend-recognized environment truth

## 第二层：`reuseEnvironmentId` 才是 request-side backend reuse claim

`types.ts` 对 `reuseEnvironmentId` 继续把层级写得很清楚：

- backend-issued `environment_id` to reuse on re-register
- must be a backend-format ID
- client UUIDs are rejected with 400

`bridgeApi.ts` 在 request body 里也只会在有值时发送：

- `environment_id: config.reuseEnvironmentId`

这说明 `reuseEnvironmentId` 回答的问题不是：

- 本地 config 里有没有一个 environment 槽位

而是：

- 这次向 backend 发起 re-register 时，我要不要显式 claim “请把我接回这条已有 env”

所以它的厚度更像：

- request-side backend reuse claim

不是：

- local config key

也不是：

- current live environment result

## 第三层：注册返回的 `environment_id` 才是当前运行时真正落成的 live env

`registerBridgeEnvironment(...)` 的返回值是：

- `environment_id`
- `environment_secret`

而 runtime 后续真正采用的也是这个 response-side `environmentId`：

- `logger.printBanner(config, environmentId)`
- `pollForWork(environmentId, environmentSecret, ...)`
- `deregisterEnvironment(environmentId)`
- `writeBridgePointer(... environmentId ...)`

这说明对当前运行时来说，

真正被拿去驱动后续 lifecycle 的不是：

- `config.environmentId`
- 也不是 `reuseEnvironmentId`

而是：

- response-side live `environmentId`

所以更准确的说法不是：

- 注册只是把原先准备好的 env 原样回显一遍

而是：

- register response 才是这次 bridge 真正上线时被 runtime 承认的 live environment

## 第四层：`createBridgeSession({ environmentId })` 继续消费的是 live env，不是前两层任意一层

`createSession.ts` 在 POST `/v1/sessions` 时会发送：

- `environment_id: environmentId`

这里的 `environmentId` 来自哪一层非常关键。

在 standalone `bridgeMain.ts` 里，它来自：

- 注册返回的 `reg.environment_id`

而不是：

- `config.environmentId`

也不是：

- `reuseEnvironmentId`

这说明 `createBridgeSession(...)` 回答的问题不是：

- “我原来想复用哪个 env”

而是：

- “我现在已经在哪个 live env 上附着新 session”

所以它的厚度更像：

- session attach target

不是：

- 本地配置键
- 也不是 request-side reuse claim

## 第五层：env mismatch 正好证明 request-side claim 与 live env 不是同一种主权

`bridgeMain.ts` 在 resume 主链里专门保留了这一句：

- 如果 `reuseEnvironmentId && environmentId !== reuseEnvironmentId`
- 就说明 backend 返回了 different `environment_id`
- 系统认为 original env expired
- 并降级成 fresh session fallback

这说明系统一开始就承认：

- request-side reuse claim 可以失败
- response-side live env 可以替换它

因此更准确的结论不是：

- `reuseEnvironmentId` 本身就等于这次 live env

而是：

- `reuseEnvironmentId` 只是 request-side claim
- `reg.environment_id` 才是 response-side ruling

只要这一层没拆开，正文就会把：

- “请求想复用哪个环境”
- “最终实际落成哪个环境”

偷换成一件事。

## 第六层：`BridgeConfig.environmentId` 与 `reuseEnvironmentId` 甚至不是同一类“请求字段”

这层更容易被忽略。

如果只看 `BridgeConfig` 类型，

很容易误以为：

- `environmentId`
- `reuseEnvironmentId`

都只是 register request 的两个 environment 参数。

但当前 register 实现并非如此：

- request body 并不发送 `config.environmentId`
- request body 会条件性发送 `config.reuseEnvironmentId`

这说明更准确的理解应是：

- `environmentId` 先活在 local config / type 层
- `reuseEnvironmentId` 才真正进入当前 register request 的 env-claim surface

所以它们不是：

- 同一 request object 里的平级主权

而是：

- 一个更像 local slot
- 一个更像 backend-facing claim

## 第七层：REPL perpetual 与 standalone 共享 register core，但不共享同一来源的 reuse claim

如果只看 `registerBridgeEnvironment(...)`，仍然不够稳。

因为 REPL perpetual 与 standalone resume 虽然都可能设置：

- `reuseEnvironmentId`

但来源不同：

### standalone `remote-control --continue`

- `reuseEnvironmentId` 来自 `getBridgeSession(...).environment_id`
- 也就是 server-side session record

### perpetual REPL init / reconnect Strategy 1

- `reuseEnvironmentId` 来自 `prior.environmentId` 或 `requestedEnvId`
- 也就是更本地化的 prior-state / current live env carry-forward

这说明更准确的说法不是：

- 所有 reuse claim 都来自同一种 authority

而是：

- register core 共享
- reuse claim provenance 仍取决于 host 和当前 recovery branch

因此这页更应该抓：

- config key / request claim / live result / attach target

而不是重新回写 173 的 pointer env vs session env 大图。

## 第八层：为什么这页不是 42、173 或 174 之前那些注册页的附录

### 不是 42 的附录

42 讲的是：

- environment
- work
- session

三类 lifecycle object 不同。

174 讲的是：

- 就连 environment 这一类对象内部，也还要继续拆成 config key、reuse claim、live result 与 attach target

前者更像 object taxonomy，
后者更像 intra-environment authority split。

### 不是 173 的附录

173 讲的是：

- pointer env
- session env
- registered env

这页讲的是：

- register chain 内部 config/reuse/live/attach 四层

173 的主语还是“truth thickness”，
174 的主语更靠近“register contract authority”。

### 不是 41 的附录

41 讲的是：

- URL
- secret
- token
- epoch

都不是同一种连接凭证。

174 讲的是：

- environment 相关字段为什么也不是同一种注册主权

前者更像 transport credential，
后者更像 environment registration authority。

## 第九层：专题内 stable / gray 也要分开

### 专题内更稳定的不变量

- `BridgeConfig.environmentId` 不会自动等于 live env。
- 当前 register request 的 env claim surface 主要是 `reuseEnvironmentId`。
- runtime 真正围绕注册返回的 `environmentId` 运转。
- `createBridgeSession(...)` 消费的是 live env，而不是 request-side claim。
- env mismatch 证明 reuse claim 与 live result 可以分裂。

### 更脆弱、应后置的细节

- OAuth refresh
- worktree / spawn mode
- pointer `source`
- compat session tag / infra session tag
- fault injection wrapper

更准确的写法不是：

- 这页在复述所有 register 相关实现

而是：

- 这页只抓 environment register authority 的层次错位

## 苏格拉底式自审

### 问：如果删掉 `reuseEnvironmentId`，这页还成立吗？

答：不成立。因为这页的核心就是 request-side reuse claim 与 live env result 不是同一种主权。

### 问：如果把 `BridgeConfig.environmentId` 直接写成“当前环境 ID”，会错在哪里？

答：会把 local config key 偷换成 backend-recognized live env，并抹掉当前 request body 并不直接发送它这一事实。

### 问：为什么必须把 `createBridgeSession({ environmentId })` 拉进来？

答：因为只有把 attach 面拉进来，才能证明注册返回的 live env 还会继续向下游变成 session attach target，而不是停在 register 阶段的抽象结果。

### 问：这页是不是又写回 173 的 env truth layering 了？

答：不是。173 讲的是 hint、truth、result；174 讲的是 register chain 里的 config key、reuse claim、live env 与 attach target。
