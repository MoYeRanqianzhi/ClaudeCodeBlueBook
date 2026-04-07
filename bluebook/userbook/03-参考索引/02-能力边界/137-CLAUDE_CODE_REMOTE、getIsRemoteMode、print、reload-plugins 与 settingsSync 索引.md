# `CLAUDE_CODE_REMOTE`、`getIsRemoteMode`、`print`、`reload-plugins` 与 `settingsSync` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/148-CLAUDE_CODE_REMOTE、getIsRemoteMode、print、reload-plugins 与 settingsSync：为什么 headless remote 分支不是 interactive remote bit 的镜像.md`
- `05-控制面深挖/147-REMOTE_SAFE_COMMANDS、filterCommandsForRemoteMode、handleRemoteInit、session 与 mobile：为什么 remote-safe 命令面不是 runtime readiness proof.md`

边界先说清：

- 这页不是 env var 总表。
- 这页不是 143 的重写版。
- 这页只抓 `CLAUDE_CODE_REMOTE` 与 `getIsRemoteMode()` 为什么不是同一根 remote 轴。

## 1. 两根 remote 轴

| 轴 | 当前更像什么 | 代表分支 |
| --- | --- | --- |
| env remote axis | headless / CCR / container runtime fact | `CLAUDE_CODE_REMOTE` |
| interactive remote axis | REPL / UI / bootstrap behavior switch | `getIsRemoteMode()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `CLAUDE_CODE_REMOTE` 就是另一种写法的 `getIsRemoteMode()` | 一个是 env fact，一个是 bootstrap bit |
| `(env || bit)` 证明两者同义 | 这更像双入口兼容 gate |
| remote 一词足以覆盖 headless 与 interactive 两类分支 | 当前 repo 已经至少有两根不同 remote 行为轴 |

## 3. 典型 consumer

| consumer | 为什么更像 env 轴 | 为什么更像 bit 轴 |
| --- | --- | --- |
| upstream proxy / plugin git transport / permission defaults / API timeout | 关心容器、网络、SSH key、policy、timeout | 不关心 UI |
| `/session` / `StatusLine` / footer modePart / startup notifications | 不关心容器 transport 细节 | 关心 REPL/front-state 行为 |
| `print.ts` / `/reload-plugins` settings sync | 同时接受 env 与 bit | 说明它们想兼容双入口，不是证明两者同义 |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | env 轴与 bit 轴分工不同；`(env || bit)` 更像兼容 gate |
| 条件公开 | 某些后续行为在双入口上共享，比如 settings sync |
| 内部/灰度层 | 哪些分支最终该 env-only、bit-only 或 dual gate，仍可能继续收敛调整 |

## 5. 五个检查问题

- 我现在写的是进程环境事实，还是 interactive behavior bit？
- 我是不是把 `(env || bit)` 误写成“二者同义”？
- 我是不是忽略了 UI 外的 env consumer，比如 proxy、permission、git transport、timeout？
- 我是不是又把 remote 压回成一根轴？
- 我是不是把 143 的 interactive remote bit 结论和本页的 env axis 结论混成一页？

## 6. 源码锚点

- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/entrypoints/init.ts`
- `claude-code-source-code/src/context.ts`
- `claude-code-source-code/src/utils/plugins/pluginLoader.ts`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts`
- `claude-code-source-code/src/services/api/claude.ts`
- `claude-code-source-code/src/upstreamproxy/upstreamproxy.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/commands/reload-plugins/reload-plugins.ts`
