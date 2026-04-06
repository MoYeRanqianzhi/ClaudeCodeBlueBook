# bridgePointer、sessionRestore 与 conversationRecovery 的续作责任边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `151` 时，  
真正需要被单独拆开的已经不是：

`谁能签 finality，谁能签 forgetting，`

而是：

`Claude Code 到底在哪里把“旧痕迹可清”继续拆成“同一责任线程仍未被释放”？`

如果这个问题只停在主线长文里，  
很容易被说成抽象哲学。  
所以这里单开一篇，只盯住：

- `src/bridge/bridgePointer.ts`
- `src/bridge/bridgeMain.ts`
- `src/utils/sessionRestore.ts`
- `src/utils/conversationRecovery.ts`

把 crash-recovery pointer、`--continue`、same-session resume、interrupted-turn continuation 这几层 continuity signal 拆给源码本身说话。

## 2. 先给最短判断

这组代码最重要的技术事实不是：

`Claude Code 支持 resume。`

而是：

`Claude Code 明确拒绝把“某些旧表面已经可以清理”压成“同一责任线程已经被免责释放”。`

因为它做了四件很硬的事：

1. pointer fresh 就保留
2. `--continue` 会跨 worktree 找 freshest continuity evidence
3. non-fatal single-session shutdown 会跳过 archive+deregister 来保住 resume honesty
4. interrupted turn 会被补成 continuation，而不是被默认为自然蒸发

这意味着它治理的不是单一 cleanup 动作，  
而是一套：

`continuity-preserving liability protocol`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| pointer 是什么 | `src/bridge/bridgePointer.ts:22-34` | 为什么它不是普通缓存，而是 crash-recovery artifact |
| pointer refresh / stale clear | `src/bridge/bridgePointer.ts:56-113` | 为什么只有 stale / invalid 才清 |
| worktree fanout | `src/bridge/bridgePointer.ts:115-180` | 为什么 continuity truth 追 freshest pointer，而不是当前目录表面 |
| resumable shutdown | `src/bridge/bridgeMain.ts:1516-1535` | 为什么 non-fatal exit 不做 archive+deregister |
| `--continue` wiring | `src/bridge/bridgeMain.ts:2162-2174` | 为什么 sibling worktree pointer 也能接回同一线程 |
| deterministic dead-end clear | `src/bridge/bridgeMain.ts:2384-2407` | 为什么只有 session gone / env missing 才清 pointer |
| transient reconnect retention | `src/bridge/bridgeMain.ts:2524-2540` | 为什么 retry 仍可能成立时不能清 pointer |
| same-session restore | `src/utils/sessionRestore.ts:403-487` | 为什么默认 resume 不是 new lineage |
| interrupted-turn continuation | `src/utils/conversationRecovery.ts:204-245` | 为什么中断会被补成待继续责任 |

## 4. `bridgePointer` 不是“方便功能”，而是 continuity artifact

`src/bridge/bridgePointer.ts:22-34` 已经写得非常明确：

1. pointer 为 crash-recovery 而设
2. 会在 bridge session 建立后立即写入
3. clean shutdown 才清理
4. 非 clean exit 会被保留下来供下次 resume

这说明 pointer 的制度地位不是：

`optional UX helper`

而是：

`同一责任线程未来仍可被重新接入的工件。`

## 5. stale / invalid clear 说明 forgetting 只能吃掉不再合法代表 continuity 的 artifact

`src/bridge/bridgePointer.ts:76-113` 的关键信息在于：

1. pointer age 由 mtime 判定
2. stale 才 clear
3. schema invalid 也 clear
4. fresh pointer 则保留

这说明源码作者并不相信一种粗暴的 forgetting：

`写完一阵子就删，省得麻烦`

它真正相信的是：

`只清掉那些已经不再配代表 continuity truth 的 artifact`

因此 pointer clear 的本质不是随手清缓存，  
而是：

`撤销一个 continuity claim 的合法性。`

## 6. worktree fanout 说明责任线程追随 freshest truth，而不是跟着 shell cwd 漂移

`src/bridge/bridgePointer.ts:115-180` 最有价值的点是：

1. 先查当前目录
2. miss 之后 fan out 到 git worktree siblings
3. 选 freshest pointer
4. 还把 pointer 所在目录带回去

这说明系统承认一个事实：

`同一责任线程的最强 continuity truth 可能不在当前表面，而在 sibling worktree。`

所以从源码作者的心智模型看：

`真正重要的不是你现在站在哪个目录，而是哪条 evidence 仍然最新、仍然合法。`

这恰好证明：

`表面可忘，不等于线程已释。`

## 7. bridge shutdown 直接把“resume honesty”写成系统义务

`src/bridge/bridgeMain.ts:1516-1535` 其实非常值得反复读：

1. single-session
2. 有 known session
3. non-fatal exit
4. 保留 session 和 environment
5. 跳过 archive+deregister
6. 因为否则 printed resume command 会是 lie

这段注释的深层含义不是单纯“方便用户继续”，  
而是：

`系统承认自己对已经打印出来的 resume promise 负有诚实义务。`

而一旦一个系统对 resume promise 负有诚实义务，  
它就已经在制度上承认：

`责任线程尚未被释放。`

## 8. deterministic dead-end 与 transient retry 被拆开，说明 release gate 依赖更强 truth

`src/bridge/bridgeMain.ts:2384-2407`：

1. session gone on server
2. 或 `environment_id` 缺失
3. 这时才 clear pointer

`src/bridge/bridgeMain.ts:2524-2540`：

1. transient reconnect failure 不得 deregister
2. fatal failure 才 clear pointer
3. 非 fatal 甚至明确提示“try running the same command again”

这说明代码里的真实判断不是：

`连接这次失败 -> 线程结束`

而是：

`只有 stronger death truth 成立 -> continuity claim 才终止`

因此 pointer / retry asset 的保留不是保守过度，  
而是：

`用更强 truth 来守住责任边界。`

## 9. `processResumedConversation()` 让 resume 默认继承同一 session identity

`src/utils/sessionRestore.ts:403-487` 最核心的事实有四个：

1. 默认复用原 session ID
2. 恢复原 transcript file pointer
3. 恢复原 worktree state
4. 恢复原 cost / mode / agent metadata

只有 `--fork-session` 才显式切到新 ID。

这说明 resume 的默认语义从来不是：

`重新开始一个近似会话`

而是：

`继续原会话。`

所以从 session identity 的制度设计看：

`Claude Code 默认选择 continuity，而不是 amnesty。`

## 10. interrupted turn 被补成 continuation，说明 unfinished obligation 不会被沉没

`src/utils/conversationRecovery.ts:204-245` 的设计其实非常深：

1. 先检测 interrupted turn
2. 再补出 `Continue from where you left off.`
3. 再补 assistant sentinel 保持 API-valid

这表明作者面对中断时的默认立场不是：

`这轮没做完，先当它过去了`

而是：

`把未完成 turn 重新编码成可继续履行的责任对象`

这正是 liability continuity 的最直接实现。

## 11. 这篇源码剖面给主线带来的三条技术启示

### 启示一

Claude Code 的 cleanup 语义已经暗含至少三层不同对象：

- trace
- continuity artifact
- release gate

### 启示二

resume honesty 是源码里真实存在的工程约束，  
它不是 UX 文案，而是会反向决定 archive / deregister / pointer-clear 的严肃条件。

### 启示三

最强的“结束”并不是眼前干净了，  
而是 future resume / retry / reopen 的权利和义务都被正式关闭了。  
而这一步，当前源码仍明显比 forgetting 更强。

## 12. 一条硬结论

这组源码真正先进的地方不是“恢复能力很多”，  
而是它在最关键的地方坚持了一条很难得的边界：

`允许清理旧表面，不等于允许释放同一责任线程。`
