# 安全恢复资格降级语法：为什么no-candidate、invalid-id、dead-session、fresh-session-fallback与retryable不能压成同一句无法恢复

## 1. 为什么在 `88` 之后还要继续写“恢复资格降级语法”

`88-安全恢复资格证据门槛` 已经回答了：

`“仍可恢复”必须建立在最小 truth bundle 之上。`

但如果继续往下追问，  
还会碰到一个更接近用户体感、也更接近控制面表达纪律的问题：

`当 truth bundle 的不同部分失败时，系统到底该怎么改口？`

因为一旦进入恢复失败场景，  
系统其实并不是只会遇到一种失败。

在源码里，至少已经存在这些完全不同的分支：

1. 没有 candidate
2. candidate id 非法
3. session 已死
4. session 存在但不可附着 bridge
5. 原边界不可续接，只能 fresh session fallback
6. 当前仍可 retry
7. 当前已经 fatal，不再可恢复

如果把它们全部压成一句：

`无法恢复`

那系统就会同时失去：

1. 对象级诊断
2. 下一步动作指引
3. promise revocation 的精度
4. 对用户时间成本的尊重

所以在 `88` 之后，  
安全专题还必须再补一章，把“证据门槛”继续推进成一套语义制度：

`恢复资格降级语法。`

也就是：

`成熟控制面不仅要判断恢复资格是否成立，还必须在资格不成立时把不同失败类型降级成不同语义，而不能继续压成同一句“恢复失败”。`

## 2. 最短结论

从 `bridgeMain.ts` 的 resume / reconnect 路径看，Claude Code 已经在用不同语句表达不同降级结果：

1. 没有 pointer candidate 时，直接报 `No recent session found ... start a new one.`  
   `src/bridge/bridgeMain.ts:2149-2160`
2. session id 非法时，直接报 `Invalid session ID ...`，说明这不是对象死亡，而是 candidate malformed  
   `src/bridge/bridgeMain.ts:2363-2373`
3. session 不存在时，报 `Session ... not found. It may have been archived or expired ...`，并清 pointer  
   `src/bridge/bridgeMain.ts:2380-2398`
4. session 没有 `environment_id` 时，报 `may never have been attached to a bridge`，说明对象存在但不具备桥接恢复资格  
   `src/bridge/bridgeMain.ts:2400-2410`
5. environment mismatch 时，不说“彻底不能恢复”，而是明确降级为 `Creating a fresh session instead.`  
   `src/bridge/bridgeMain.ts:2473-2489`
6. reconnect failure 若是 transient，则保留 `may still be resumable — try running the same command again`  
   `src/bridge/bridgeMain.ts:2524-2540`
7. 若是 fatal，则不再使用 retry 语气，而是直接按不可恢复处理  
   `src/bridge/bridgeMain.ts:2527-2540`

所以这一章的最短结论是：

`Claude Code 的恢复失败不是单一状态，而是一套分层降级语法。`

我把它再压成一句：

`恢复资格失败不是一个点，而是一条梯子。`

## 3. 源码已经说明：不同失败必须落到不同语义，而不能再压平

## 3.1 `No recent session found` 不是“恢复失败”，而是“根本没有候选对象”

`src/bridge/bridgeMain.ts:2149-2160` 的输出非常克制：

`No recent session found in this directory or its worktrees. Run \`claude remote-control\` to start a new one.`

这里系统并没有说：

`某个旧边界已经死了`

也没有说：

`当前恢复尝试失败`

它真正表达的是：

`当前根本没有候选恢复对象。`

这属于最早层级的降级：

`no-candidate`

下一步动作也很清楚：

`start a new one`

如果把这种情况压成 generic 恢复失败，  
就会把“没有候选”和“有候选但候选已死”混成一类。

## 3.2 `Invalid session ID` 不是边界死亡，而是候选对象格式不合法

`src/bridge/bridgeMain.ts:2363-2373` 处理的是另一种完全不同的错误：

`Invalid session ID ... Session IDs must not contain unsafe characters.`

这说明系统已经在把：

1. candidate malformed
2. candidate dead

明确分开。

因为这里还根本没有进入对象存在性判断，  
所以不能说：

`找不到`

更不能说：

`边界已退役`

这类错误的本质是：

`输入对象不配进入恢复资格判断。`

它是语法级降级，  
不是生命周期级降级。

## 3.3 `Session not found` 才是典型的 dead-session 降级

`src/bridge/bridgeMain.ts:2380-2398` 对 `!session` 的处理，  
就和上面完全不同了。

这里作者明确说：

1. session 不存在
2. 可能已 archived / expired
3. pointer stale
4. 应该 clear pointer

这说明这里已经不是 candidate 问题，  
而是：

`对象级死亡`

它对应的语义应当是：

`dead-session`

这类降级会触发：

1. promise revocation
2. pointer cleanup
3. 用户不应再继续追索这个对象

所以它显然不能与 `no-candidate` 或 `invalid-id` 同句处理。

## 3.4 `has no environment_id` 是另一种独立降级：对象存在，但不可桥接恢复

`src/bridge/bridgeMain.ts:2400-2410` 的这条错误尤其有价值。

系统没有说：

`session 死了`

而是说：

`Session ... has no environment_id. It may never have been attached to a bridge.`

这说明这里的对象是存在的，  
但它不属于：

`可桥接恢复对象族`

因此这是另一类完全独立的降级：

`non-attachable object`

从第一性原理看，  
这比 `session not found` 更微妙。  
因为对象存在，  
只是它不满足恢复协议的对象类型要求。

如果把它压成 generic 无法恢复，  
系统就失去了很关键的解释力：

`不是对象死了，而是它从来就不是这种恢复路径的合法对象。`

## 3.5 `Creating a fresh session instead` 是降级，不是失败

`src/bridge/bridgeMain.ts:2473-2489` 是恢复链里很重要的一种中间语义。

当 `environmentId !== reuseEnvironmentId` 时，  
系统不会说：

`彻底不能继续`

它说的是：

`Could not resume session ... Creating a fresh session instead.`

这说明环境不匹配对应的不是彻底失败，  
而是：

`fresh-session-fallback`

也就是：

1. 不能继续原边界
2. 但仍能继续工作
3. 只是从恢复语义降级成新建语义

这是一种非常成熟的表达。  
因为它承认：

`resumability 失败`  
并不等于  
`workability 失败`

这两件事必须分开。

## 3.6 `may still be resumable` 与 fatal error 的差别，说明 retryable 必须单列

`src/bridge/bridgeMain.ts:2524-2540` 又把另一种中间状态单独拎了出来。

这里作者明确区分：

1. fatal  
   直接 error
2. transient  
   `The session may still be resumable — try running the same command again.`

这说明在 Claude Code 里，  
恢复资格失败至少还分：

1. 当前不可恢复且无 retry path
2. 当前未恢复成功但仍有 retry path

第二种绝不能压成 generic failure。  
否则用户会：

1. 提前放弃本可恢复的边界
2. 或误以为系统已正式撤回 promise

因此：

`retryable`

必须成为独立降级层。

## 3.7 第一性原理：恢复资格失败至少包含七种不同语义

把这些源码再压一层，  
Claude Code 实际已经隐含出至少七种恢复资格结果：

1. `resumable`
2. `no-candidate`
3. `invalid-candidate`
4. `dead-session`
5. `non-attachable-object`
6. `fresh-session-fallback`
7. `retryable`
8. `fatal-nonresumable`

从第一性原理看，  
系统之所以必须把这些语义分开，  
是因为它们分别回答的是不同问题：

1. 有没有候选
2. 候选是否合法
3. 对象是否还活着
4. 对象是否属于可恢复对象族
5. 原边界能否续接
6. 是否仍存在 retry 路径
7. 是否应直接转入新建

如果把这些问题压平，  
系统就会失去：

`面向下一步动作的解释能力。`

## 3.8 技术先进性：Claude Code 已经在用结果语法而不是单点报错

从技术角度看，  
很多系统会把整个恢复链压成：

1. success
2. failure

但 Claude Code 在这里更先进的地方在于：

1. 它把 failure 前拆成 candidate 层、object 层、binding 层、continuity 层、retry 层
2. 它让不同降级结果对应不同 cleanup 和不同下一步
3. 它区分 resume 失败与 fresh fallback
4. 它区分 retryable 与 retired

这说明它真正做的不是“多写几句错误文案”，  
而是：

`把恢复资格失败建模成一套语义梯子。`

## 4. 安全恢复资格降级语法的最短规则

把这一章压成最短规则，就是下面七句：

1. 恢复资格失败不能压成一个统一错误
2. no-candidate、invalid-candidate、dead-session、non-attachable-object 必须分开
3. fresh-session-fallback 不等于恢复失败，它是从 resumability 降级到 new-session continuity
4. retryable 必须与 fatal-nonresumable 严格区分
5. 每种降级都应绑定不同 cleanup 和不同下一步动作
6. 成熟控制面不是只判断能不能恢复，还要判断该如何改口
7. 结果语法越精确，用户越不容易围绕错误对象继续耗时

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
下一步最值得补的三项升级会是：

1. 把这些降级语义建成正式 enum，而不只散在错误字符串与 if 分支里
2. 给每个 downgrade 绑定统一 `next_action` / `cleanup_policy` / `promise_state`
3. 在统一安全控制台里把当前 resumability result grammar 直接显示出来，而不是让用户从报错文案反推

所以这一章最终沉淀出的设计启示是：

`成熟安全系统不只是判定恢复资格成败，它还必须把失败精确降级成不同语义，以保护用户不被错误结果语法误导。`
