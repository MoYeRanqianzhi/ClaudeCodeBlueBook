# 图解：Bridge、Trusted Device 与 401 Recovery 精细时序

## 1. 为什么还要再加一张更细的时序图

`risk/14` 已经给出总图。  
这一章补的是更细粒度的内部时序，回答三个更技术的问题：

1. bridge 为什么会对 401 如此敏感？
2. trusted device 为什么必须紧跟 fresh login？
3. 为什么系统要同时处理 refresh、reconnect、backoff 和 fatal teardown？

## 2. Bridge 401 Recovery 精细时序

```mermaid
sequenceDiagram
    participant REPL as REPL / Remote Bridge
    participant API as bridge API / SSE
    participant AUTH as OAuth token state
    participant KEY as keychain / secure storage
    participant SRV as server credentials endpoint

    REPL->>API: 发送请求 / 维持 SSE
    API-->>REPL: 401
    REPL->>AUTH: 标记 auth recovery in flight
    REPL->>KEY: 读取当前 token / stale token
    alt 另一个进程已刷新
        KEY-->>REPL: 新 token 已存在
        REPL->>SRV: fetchRemoteCredentials
        SRV-->>REPL: 新 session/transport credentials
        REPL->>API: rebuild transport
        API-->>REPL: 恢复连接
    else 当前 token 仍是旧 token
        REPL->>AUTH: handleOAuth401Error(stale)
        AUTH->>KEY: clear cache / async re-read
        AUTH->>KEY: 需要时 refresh token
        alt refresh 成功
            KEY-->>AUTH: fresh token
            AUTH-->>REPL: refreshed = true
            REPL->>SRV: fetchRemoteCredentials
            SRV-->>REPL: 新 credentials
            REPL->>API: rebuild transport
        else refresh 失败
            AUTH-->>REPL: refreshed = false
            REPL-->>REPL: state = failed
        end
    end
```

### 图解结论

这里最重要的技术判断是：

- 401 recovery 不是“再试一次”。
- 它是“身份恢复 -> 凭证重取 -> transport 重建”的组合流程。

## 3. 为什么系统还要做 cross-process backoff

```mermaid
flowchart TD
    A[失效 token 出现] --> B[多个路径几乎同时发请求]
    B --> C[全部命中 401]
    C --> D[如果没有去重与 backoff]
    D --> E[重复清缓存]
    D --> F[重复 keychain 读取]
    D --> G[重复 refresh]
    D --> H[重复 bridge 注册]
    H --> I[401 风暴 / 支持噪声 / 用户误伤放大]

    C --> J[如果有 dedupe + backoff + failure cap]
    J --> K[单次恢复尝试]
    J --> L[连续失败后停止 guaranteed-fail 调用]
    L --> M[错误被收敛到正确层]
```

### 图解结论

这解释了为什么“失败风暴控制”本身也是风控设计的一部分。  
一个不能抑制认证失败扩散的系统，最终会对正常用户也不公平。

## 4. Trusted Device Enrollment 精细时序

```mermaid
sequenceDiagram
    participant U as 用户
    participant LOGIN as /login
    participant GB as GrowthBook gate
    participant TD as trustedDevice client logic
    participant API as /auth/trusted_devices
    participant STORE as secure storage

    U->>LOGIN: fresh login
    LOGIN->>GB: refresh gate context
    GB-->>TD: trusted device gate on/off
    alt gate off
        TD-->>U: 跳过 enrollment
    else gate on
        TD->>TD: 检查 env override / essential-traffic / OAuth token
        alt 不满足前提
            TD-->>U: 跳过 enrollment
        else 满足前提
            TD->>API: POST /auth/trusted_devices
            Note over API: 仅在 account_session.created_at < 10min 成立
            alt 200/201
                API-->>TD: device_token
                TD->>STORE: persist token
                STORE-->>TD: success
            else 403 stale_session 或其他失败
                API-->>TD: enrollment failed
                TD-->>U: 不阻塞 login，但高安全链路可能后续失败
            end
        end
    end
```

### 图解结论

trusted device 的关键不在“有没有 token”，而在：

- 是否处于 fresh login 窗口
- 是否处在正确 gate、流量级别和身份上下文里

这说明它不是普通持久化字段，而是 step-up auth 过程的一部分。

## 5. REPL Fatal Error 精细时序

```mermaid
sequenceDiagram
    participant POLL as bridge/repl poll loop
    participant ERR as BridgeFatalError
    participant UI as user-visible state
    participant CLEAN as teardown/cleanup

    POLL->>ERR: 收到 401/403/404/410
    alt suppressible 403
        ERR-->>UI: 不展示强错误文案
        ERR-->>CLEAN: 仍然 teardown
    else expiry/auth failure
        ERR-->>UI: session expired / reconnect guidance
        ERR-->>CLEAN: teardown
    else hard fatal
        ERR-->>UI: fatal message
        ERR-->>CLEAN: teardown
    end
```

### 图解结论

这里可以看出一个很成熟的取舍：

- 并非所有 403 都应该吓用户。
- 但即便用户不需要看到强报错，系统仍然要把高安全链路 teardown 干净。

## 6. 技术启示

这组时序图给构建者的启示很明确：

1. 高安全远程能力不要复用普通请求恢复逻辑。
2. 401 recovery 要包含 transport rebuild，而不只是 token refresh。
3. step-up auth 与 token expiry 必须明确区分。
4. 跨进程失败风暴治理本身要进入架构设计。
5. 某些错误可以 suppress UI，但不能 suppress cleanup。

## 7. 一句话总结

Bridge / trusted device / 401 recovery 这些源码最有价值的地方，不在于它们“更复杂”，而在于它们把高安全会话当成独立系统认真设计了。
