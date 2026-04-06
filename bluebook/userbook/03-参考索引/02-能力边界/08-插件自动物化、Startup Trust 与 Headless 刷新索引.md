# 插件自动物化、Startup Trust 与 Headless 刷新索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/19-插件自动物化、Startup Trust 与 Headless 刷新：为什么插件有时会自己出现、有时只提示 ／reload-plugins.md`
- `05-控制面深挖/18-插件安装、待刷新与当前会话激活：为什么 ／reload-plugins 不是安装器.md`

## 1. 自动链的四层对象

| 层 | 核心问题 | 典型对象 | 最容易误判 |
| --- | --- | --- | --- |
| Trust 层 | 当前交互会话是否允许推进插件自动链 | `performStartupChecks()` 前的 workspace trust | 误写成纯 UI 提示 |
| 物化层 | marketplace / plugin 是否已同步到磁盘 | seed marketplace、background install、headless install | 误写成当前会话已生效 |
| 激活层 | 当前 session 是否已换成新的 active components | `refreshActivePlugins()` | 误写成安装流程本身 |
| 通知层 | 自动链是否停在“待用户刷新” | `needsRefresh`、/reload-plugins notice | 误写成失败状态 |

## 2. 三条常见路径

| 路径 | 更准确的理解 |
| --- | --- |
| 交互 REPL startup | 先过 trust，再可能做后台物化，未必自动激活 |
| background install | 主要推进 marketplace / plugin 物化；新装时更可能 auto-refresh |
| headless / print | 更强调 first query 前可用，必要时会主动 refresh |

## 3. `needsRefresh` 到底在说什么

| 现象 | 更准确的含义 |
| --- | --- |
| UI / 通知提示 Run `/reload-plugins` | 自动链在激活层之前停住了 |
| seed marketplace 变化后 `needsRefresh` | 声明/物化变了，但当前 session 还没换栈 |
| background update 后 `needsRefresh` | 更新已完成，但系统把应用时机留给用户 |

## 4. 自动刷新与手动刷新

| 类型 | 触发者 | 共用底座 |
| --- | --- | --- |
| 手动刷新 | 用户 `/reload-plugins` | `refreshActivePlugins()` |
| 后台自动刷新 | 新 marketplace install 等特定路径 | `refreshActivePlugins()` |
| headless 刷新 | print / CCR / sync install 路径 | `refreshActivePlugins()` |

## 5. 五个高价值判断问题

- 当前卡在 trust、物化，还是激活层？
- 这条路径是交互 REPL、background install，还是 headless？
- 这里的变化是“已装到磁盘”，还是“当前 session 已换栈”？
- 这条 `needsRefresh` 是失败，还是只是停在激活前？
- 我是不是把自动路径和 `/reload-plugins` 写成了两个完全不同系统？

## 源码锚点

- `claude-code-source-code/src/utils/plugins/performStartupChecks.tsx`
- `claude-code-source-code/src/services/plugins/PluginInstallationManager.ts`
- `claude-code-source-code/src/utils/plugins/headlessPluginInstall.ts`
- `claude-code-source-code/src/utils/plugins/refresh.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/hooks/useManagePlugins.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/setup.ts`
