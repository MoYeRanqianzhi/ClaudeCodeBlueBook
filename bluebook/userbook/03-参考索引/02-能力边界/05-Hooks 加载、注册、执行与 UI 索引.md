# Hooks 加载、注册、执行与 UI 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/16-Hooks 的加载、注册、执行与 UI：为什么 ／hooks 看到的不是实际会跑的 hooks.md`
- `05-控制面深挖/14-来源信任、Trust Dialog 与 Plugin-only Policy：扩展面为何分级信任.md`

## 1. hooks 的四层不同问题

| 层 | 核心问题 | 典型对象 | 最容易误判 |
| --- | --- | --- | --- |
| 加载层 | 哪些来源先被读进来 | settings snapshot | 误写成运行时真相 |
| 注册层 | 哪些 hooks 被挂到当前 session | plugin hooks、session hooks、frontmatter hooks | 误写成“对象存在就会注册” |
| 执行层 | 当前策略与 trust 下哪些真的会跑 | managed-only、disable-all、workspace trust | 误写成“菜单里看见就会执行” |
| UI 层 | `/hooks` 现在给人展示什么 | HooksConfigMenu | 误写成权威总表 |

## 2. 四类 hooks 从哪里进入运行时

| 类别 | 主要入口 | 说明 |
| --- | --- | --- |
| settings hooks | `hooksConfigSnapshot` | 先被快照化，再进入运行聚合 |
| plugin hooks | registered hooks | 独立于 settings snapshot 的注册通道 |
| session hooks | session memory | 当前 session 的内存态 hooks |
| skill / agent frontmatter hooks | registration sites | 先过来源与 surface 判断，再进入 session hooks 链 |

## 3. 三种策略分别卡哪一层

| 策略 | 主要作用层 | 更准确的理解 |
| --- | --- | --- |
| `strictPluginOnlyCustomization['hooks']` | 来源层、注册层 | 收缩 settings hooks 来源，并阻断非 admin-trusted frontmatter hooks 注册 |
| `allowManagedHooksOnly` | 执行层 | 只保留 managed hooks，跳过 plugin hooks、session hooks 与相关加载链 |
| `disableAllHooks` from `policySettings` | 执行层 | 真正的 hooks 全停 |
| `disableAllHooks` from non-managed source | 执行层 | 更接近 managed-only，而不是绝对全停 |

## 4. `/hooks` 看得到什么，不等于什么会执行

| 对象 | UI 可能看到 | 运行时可能发生 |
| --- | --- | --- |
| settings hooks | 可见 | 仍可能被 managed-only / plugin-only / trust 拦住 |
| plugin hooks | 可见 | managed-only 下会被跳过 |
| session hooks | 可见 | managed-only 下会被跳过 |
| frontmatter hooks | 可能看得到对象来源 | 若注册门没过，就不会真正进入执行链 |

## 5. workspace trust 的统一前置条件

| 结论 | 含义 |
| --- | --- |
| 交互模式下所有 hooks 都要求 workspace trust | 不是只有 Trust Dialog 里显式列出的对象才受信任边界约束 |
| `/hooks` 菜单不是 trust 判定器 | 菜单可见与 trust 通过不是同一回事 |

## 6. hooks 邻域里的专用旁路

| 对象 | 为什么不能直接当普通 hooks 事件写 |
| --- | --- |
| `statusLine` | 共享 trust / managed-only 语义，但走专用命令路径 |
| `fileSuggestion` | 同上，属于 hooks 邻域的专用旁路命令 |

## 7. 六个高价值判断问题

- 我现在卡在加载、注册、执行，还是 UI 可见层？
- 这个 hooks 对象来自 settings、plugin、session，还是 frontmatter？
- 这里的策略改写的是来源面，还是直接改写执行面？
- 这条 hook 是真被停掉了，还是只是 UI 仍把它显示出来？
- 这里的问题是 policy gating，还是 workspace trust 没过？
- 我是不是把 `statusLine` / `fileSuggestion` 误写成了普通 hooks 事件？

## 源码锚点

- `claude-code-source-code/src/commands/hooks/index.ts`
- `claude-code-source-code/src/commands/hooks/hooks.tsx`
- `claude-code-source-code/src/components/hooks/HooksConfigMenu.tsx`
- `claude-code-source-code/src/components/hooks/SelectEventMode.tsx`
- `claude-code-source-code/src/utils/hooks/hooksSettings.ts`
- `claude-code-source-code/src/utils/hooks/hooksConfigSnapshot.ts`
- `claude-code-source-code/src/utils/hooks.ts`
- `claude-code-source-code/src/utils/sessionStart.ts`
- `claude-code-source-code/src/utils/hooks/hooksConfigManager.ts`
