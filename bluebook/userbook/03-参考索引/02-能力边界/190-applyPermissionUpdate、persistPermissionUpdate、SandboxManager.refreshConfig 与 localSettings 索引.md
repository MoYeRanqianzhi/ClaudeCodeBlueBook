# `applyPermissionUpdate`、`persistPermissionUpdate`、`SandboxManager.refreshConfig` 与 `localSettings` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/202-applyPermissionUpdate、persistPermissionUpdate、SandboxManager.refreshConfig 与 localSettings：为什么 sandbox permission 的 persist-to-settings 不是一次单层 permission 写入.md`
- `05-控制面深挖/201-hostPattern.host、sandboxBridgeCleanupRef、sandboxPermissionRequestQueue filter、onResponse unsubscribe 与 cancelRequest：为什么 sandbox network bridge 的同 host sibling cleanup 不是同一种 tool-level permission closeout.md`

边界先说清：

- 这页不是 same-host sibling sweep 总页。
- 这页不是 remote session tool plane 总页。
- 这页只抓 sandbox permission 的 persist 手势落到哪几层写面。

## 1. 七层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `SANDBOX_NETWORK_ACCESS_TOOL_NAME` | bridge / SDK 里的 synthetic transport shell | `structuredIO.ts` |
| `WEB_FETCH_TOOL_NAME` + `domain:host` | 最终落盘的本地规则目标 | `REPL.tsx` |
| `applyPermissionUpdate(...)` | leader 本地 in-memory permission context mutation | `REPL.tsx` / `PermissionUpdate.ts` |
| `persistPermissionUpdate(...)` | durable settings writer | `PermissionUpdate.ts` |
| `localSettings` | persist destination，不是 live runtime 本身 | `PermissionUpdate.ts` |
| `SandboxManager.refreshConfig()` | sync sandbox runtime refresh | `REPL.tsx` / `sandbox-adapter.ts` |
| `settingsChangeDetector.subscribe(...)` | eventual background config sync | `sandbox-adapter.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| synthetic `SandboxNetworkAccess` ask = 最终被持久化的规则本体 | transport shell 和最终写入 `WEB_FETCH_TOOL_NAME` / `domain:host` 的规则不是同一张 ledger |
| 点了 persist = 只是把规则写进 `localSettings` | 实际同时牵动 in-memory context、durable settings 与 live sandbox runtime |
| `applyPermissionUpdate(...)` 已经改了权限，所以不用 persist | 它只改 leader 本地 context，不负责磁盘持久化 |
| `persistPermissionUpdate(...)` 写完设置就等于当前 sandbox 已更新 | live sandbox 还要靠 `refreshConfig()` 或 settings change subscription |
| `refreshConfig()` 只是重复调用 | 注释明确说它用来避免 settings change 尚未被探测时的竞态窗口 |
| local sandbox 与 worker sandbox 的 persist 分支完全一样 | 本地分支可持久化 allow/deny，worker 分支只在 allow 时持久化 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | persist 手势不是单写面，而是 context / settings / runtime 三层传播 |
| 条件公开 | worker sandbox 分支只在 `persistToSettings && allow` 时写规则；`refreshConfig()` 只有 sandbox 启用时才真正生效 |
| 内部/灰度层 | `settingsChangeDetector.subscribe(...)` 的异步更新与 `BaseSandboxManager.updateConfig(...)` 的内部运行细节 |

## 4. 六个检查问题

- 我现在写的是 same-host queue sweep，还是 persist 手势的写面传播？
- 我是不是把 `applyPermissionUpdate(...)` 误写成了磁盘持久化？
- 我是不是把 synthetic `SandboxNetworkAccess` 误写成了最终落到本地设置的规则本体？
- 我是不是把 `persistPermissionUpdate(...)` 误写成了 live sandbox 已即时生效？
- 我是不是忽略了 `refreshConfig()` 注释里那句 “avoid race conditions”？
- 我是不是把 local sandbox 和 worker sandbox 的 persist 分支写成同一条？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/utils/permissions/PermissionUpdate.ts`
- `claude-code-source-code/src/utils/sandbox/sandbox-adapter.ts`
