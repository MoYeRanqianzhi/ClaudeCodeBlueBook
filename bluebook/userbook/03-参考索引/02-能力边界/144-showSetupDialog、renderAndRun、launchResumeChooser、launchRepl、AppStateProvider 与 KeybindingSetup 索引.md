# `showSetupDialog`、`renderAndRun`、`launchResumeChooser`、`launchRepl`、`AppStateProvider` 与 `KeybindingSetup` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/155-showSetupDialog、renderAndRun、launchResumeChooser、launchRepl、AppStateProvider 与 KeybindingSetup：为什么 setup-dialog host 与 attached REPL host 不是同一种 interactive host.md`
- `05-控制面深挖/154-discoverAssistantSessions、launchAssistantInstallWizard、launchAssistantSessionChooser、createRemoteSessionConfig 与 attach banner：为什么 claude assistant 的发现、安装、选择与附着不是同一种 connect flow.md`

边界先说清：

- 这页不是 assistant 入口链重写版。
- 这页不是所有 interactive helper 的总表。
- 这页只抓 setup-dialog host 与长期 REPL/app host 的差异。

## 1. 两类宿主

| 宿主 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| setup-dialog host | 展示一次性设置/选择 UI，拿到结果就返回 | `showSetupDialog(...)`、assistant install wizard、assistant chooser |
| attached/full REPL host | 渲染长期运行的 interactive app，直到 root 退出 | `renderAndRun(...)`、`launchRepl(...)`、`<App><REPL/>` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| install / chooser / attach 只是同一宿主里的不同 UI | install/chooser 与 attach REPL 属于不同 host family |
| chooser/picker 一定就是 setup dialog | `launchResumeChooser(...)` 就是反例 |
| `KeybindingSetup` 两边都用了，所以宿主相同 | 共享包装件不等于共享宿主合同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `showSetupDialog(...)` vs `renderAndRun(...)` 的合同差异；assistant chooser/install 与 launchRepl 的宿主差异 |
| 条件公开 | 某些 chooser 会落在哪个宿主，取决于调用方选择 |
| 内部/灰度层 | 未来 interactive helper 继续抽象后宿主边界是否会重组，仍可能调整 |

## 4. 五个检查问题

- 我现在写的是 setup-dialog host，还是长期 interactive host？
- 我是不是把 chooser 业务误当成宿主类型？
- 我是不是忽略了 `launchResumeChooser(...)` 这个反例？
- 我是不是把共享的 `KeybindingSetup` 误写成共享的宿主合同？
- 我是不是又把 154 写了一遍？

## 5. 源码锚点

- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/src/dialogLaunchers.tsx`
- `claude-code-source-code/src/replLauncher.tsx`
- `claude-code-source-code/src/main.tsx`
