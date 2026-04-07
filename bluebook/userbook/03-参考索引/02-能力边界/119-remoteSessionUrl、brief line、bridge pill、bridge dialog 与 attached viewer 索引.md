# `remoteSessionUrl`、brief line、bridge pill、bridge dialog 与 attached viewer 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/130-remoteSessionUrl、brief line、bridge pill、bridge dialog 与 attached viewer：为什么它们不是同一种 surface presence.md`
- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`
- `05-控制面深挖/26-Connect URL、Session URL、Environment ID、Session ID 与 remoteSessionUrl：为什么 remote-control 的链接、二维码与 ID 不是同一种定位符.md`

边界先说清：

- 这页不是 bridge 配置页。
- 这页不是 URL / ID 定位符页。
- 这页不替代 25。
- 这页不替代 26。
- 这页只抓几种“都像远端存在”的 surface 为什么不是同一种 presence。

## 1. 五种 surface presence

| surface | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| `remoteSessionUrl` | 这条 REPL 是否带着一个可打开的 `--remote` session URL | `main.tsx`、`/session`、footer `remote` pill |
| brief line | brief-only idle 时是否有 remote runtime 告警与后台任务计数 | `BriefIdleStatus` |
| bridge pill | 当前系统是否愿意给出 coarse bridge status summary | `BridgeStatusIndicator` |
| bridge dialog | 当前 bridge 连到哪里、现在能不能 inspect / disconnect | `BridgeDialog` |
| attached viewer | 当前这条会话是否已附着到某个 assistant session | attach path transcript info message |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| footer 有 `remote` 就说明当前连接健康 | `remote` pill 当前只签 `remoteSessionUrl` presence |
| brief line 就是在显示 remote URL 状态 | brief line 只读 `remoteConnectionStatus` 与 `remoteBackgroundTaskCount` |
| bridge pill 缺席就说明没有 bridge | implicit bridge 非 reconnecting 时，pill 会故意隐藏 |
| bridge dialog 是 bridge pill 的放大版 | dialog 属于 inspect / disconnect surface |
| attached viewer 的 presence 主要靠 URL | attach path 当前主要靠 transcript info message 签名 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `remoteSessionUrl` 属于 `--remote` URL 链；brief line 属于 brief-only runtime projection；bridge pill 属于 coarse summary；bridge dialog 属于 inspect / disconnect；attached viewer 当前靠 attach transcript 签名 |
| 条件公开 | bridge pill 有显式 gate；brief line 只有在 brief-only idle 条件满足时出现；dialog 主 URL 会在 `connectUrl` / `sessionUrl` 间切换；attached viewer 会写 runtime 状态但不自动长出 `remoteSessionUrl` |
| 内部/灰度层 | footer `remote` pill 的 lazy capture；bridge pill 的导航同步 gate；`useReplBridge` 对 URL / ID 的填充清空细节 |

## 4. 五个检查问题

- 我现在写的是 URL presence、runtime projection，还是 transcript signer？
- 我是不是把 bridge pill 的缺席写成了 bridge 的缺席？
- 我是不是把 dialog 错写成了 pill 的展开态？
- 我是不是把 attached viewer 写成了 `--remote` URL mode？
- 我是不是把当前 render gate / lazy capture 写成了稳定产品合同？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/commands/session/session.tsx`
