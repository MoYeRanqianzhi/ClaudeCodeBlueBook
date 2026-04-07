# `SENTINEL_LOADING`、`SENTINEL_LOADING_FAILED`、`SENTINEL_START`、`useAssistantHistory`、`remoteConnectionStatus` 与 `BriefIdleStatus` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/153-SENTINEL_LOADING、SENTINEL_LOADING_FAILED、SENTINEL_START、maybeLoadOlder、fillBudgetRef、remoteConnectionStatus 与 BriefIdleStatus：为什么 attached viewer 的历史翻页哨兵不是 remote presence surface.md`
- `05-控制面深挖/58-viewerOnly、hasInitialPrompt、useAssistantHistory 与 updateSessionTitle：为什么 attached assistant REPL 的首问加载、历史翻页与会话标题不是同一种主权.md`
- `05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`
- `05-控制面深挖/151-getSessionId、switchSession、StatusLine、assistant viewer、remoteSessionUrl 与 useRemoteSession：为什么 remote.session_id 可见，不等于当前前端拥有那条 remote session.md`

边界先说清：

- 这页不是 attached viewer history 总表。
- 这页不是 replay dedup 页，也不是 ownership 页。
- 这页只抓 transcript 顶部分页哨兵与 remote presence ledger 的差异。

## 1. 两张面

| 面 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| history paging 面 | transcript 顶部还能不能继续往旧页翻 | `SENTINEL_LOADING`、`FAILED`、`START`、`cursorRef`、`maybeLoadOlder`、`fillBudgetRef` |
| remote presence 面 | 远端 live 连接与后台任务当前怎样 | `remoteConnectionStatus`、`remoteBackgroundTaskCount`、`BriefIdleStatus` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `loading older messages…` 就是远端在 reconnect | 它首先是 older-page paging sentinel |
| `start of session` 是远端当前 idle / connected 的一种提示 | 它只说明 transcript 顶部到头 |
| 顶部 retry 文案说明 remote daemon 有问题 | 它只说明 older-page fetch 失败，可重试 |
| brief warning 和 history paging 本质一样 | 它们来自不同账本、不同 consumer |

## 3. 宿主视角速查

| 对象 | 当前更像什么 |
| --- | --- |
| `useAssistantHistory` | attached viewer 的 transcript paging 状态机 |
| `REPL` + `maybeLoadOlder` | scroll-up 触发 older-page fetch |
| `useRemoteSession` | live remote presence writer |
| `BriefIdleStatus` | remote presence 的 brief consumer |

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | sentinel 属于 paging 面； `remoteConnectionStatus` / `remoteBackgroundTaskCount` 属于 presence 账 |
| 条件公开 | sentinel 只在 viewer history 分页时出现；brief 状态只在对应 runtime 条件下出现 |
| 内部/灰度层 | paging retry 文案与 viewport fill 策略仍可能继续细化 |

## 5. 五个检查问题

- 我现在写的是 transcript paging，还是 remote runtime presence？
- 我是不是把顶部 sentinel 误写成 reconnect / disconnect？
- 我是不是忽略了 `fillBudgetRef` / `anchorRef` 处理的是滚动几何？
- 我是不是忽略了 `BriefIdleStatus` 根本不读 sentinel？
- 我是不是又把 58/118/123/151 的结论压回一页？

## 6. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/state/AppStateStore.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
