# builder transport、public SDK、direct-connect callback 与 UI consumer 可见性分层 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/111-controlSchemas、agentSdkTypes、directConnectManager、useDirectConnect 与 sdkMessageAdapter：为什么 builder transport、callback surface 与 UI consumer 不是同一张可见性表.md`
- `05-控制面深挖/108-StdoutMessage、SDKMessage、onMessage 与 post_turn_summary：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`
- `05-控制面深挖/110-streamlined_*、post_turn_summary、createStreamlinedTransformer 与 directConnectManager：为什么同样在过滤名单里，却不是同一种 suppress reason.md`

边界先说清：

- 这页不是 SDK message 全表。
- 这页不替代 108 对单个 callback narrowing 的拆分。
- 这页不替代 110 对同一 skip list 内 family provenance 差异的拆分。
- 这页只抓 builder/control transport、public/core SDK、direct-connect callback 与 UI consumer 为什么不是同一张可见性表。

## 1. 四层对象总表

| 层级 | 在这里回答什么 | 更接近什么 |
| --- | --- | --- |
| `controlSchemas` / `StdoutMessageSchema` | stdout/control wire 允许承载什么 | builder/control transport table |
| `agentSdkTypes` / `SDKMessage` | public SDK 默认暴露什么 | narrower public/core table |
| `directConnectManager.onMessage` | transport ingress 后还能转发什么 | callback table |
| `useDirectConnect` + `sdkMessageAdapter` | callback 对象里最终哪些会进 UI | UI consumer table |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `controlSchemas.ts` 和 `agentSdkTypes.ts` 只是同一张表的两种写法 | 前者面向 builder/control transport，后者面向 public/core SDK |
| parse gate 过了，就等于 callback 和 UI 都能看见 | callback 和 UI 还会继续层层收窄 |
| 进入 `onMessage` 的对象就一定能进 transcript | adapter 会继续把很多对象判成 `ignored` |
| 不在 `SDKMessageSchema` 里，就等于 transport 不承认 | `StdoutMessageSchema` 本来就更宽 |
| Claude Code 只有一张消息可见性表 | 当前源码至少展示了四张逐级收窄的表 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `controlSchemas` 明说 builders 看 control protocol；`agentSdkTypes` 明说 public API 看 core/runtime；direct connect callback 与 UI consumer 继续收窄 |
| 条件公开 | 某个 family 在某层是否实际出现，还取决于 upstream emit、manager filter、adapter policy 与运行时 gate |
| 内部/灰度层 | 各层具体 family 的覆盖完整度、不同宿主是否完全复用这四层、每一层的运行时常见度 |

## 4. 六个检查问题

- 当前问的是 transport、public SDK、callback，还是 UI consumer？
- 我是不是把同一对象在不同层的答案压成了一句“可见/不可见”？
- 我是不是把 callback 结果直接写成了 UI 结果？
- 我是不是把 `controlSchemas` 写成了 public SDK 定义文件？
- 我是不是把 family 个案结论误当成整张表的结论？
- 我有没有忘记 direct connect 只是这组分层里的一个宿主路径？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/agentSdkTypes.ts`
- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
