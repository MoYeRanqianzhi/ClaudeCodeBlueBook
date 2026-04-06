# `remoteDialogSeen`、multi-session gate、`ProjectConfig.remoteControlSpawnMode` 与 effective `spawnMode`：为什么 standalone remote-control 的一次性说明、账号资格、项目偏好与当前模式不是同一个默认

## 用户目标

不是只知道 standalone `claude remote-control` 启动时“有时先弹一次说明、有时说 multi-session 还没开、有时记住上次的 worktree / same-dir、有时又直接落到 single-session”，而是先分清六类不同对象：

- 哪些只是第一次启用 standalone host 时的一次性说明与同意。
- 哪些是在判断当前账号有没有 multi-session 资格。
- 哪些是在记录这个项目上次选择的 spawn preference。
- 哪些是在当前启动命令里显式覆盖 preference。
- 哪些是在 resume 场景下被强制收窄成 single-session。
- 哪些才是当前这一次真正生效的 `spawnMode`。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“默认 remote-control 设置”：

- `remoteDialogSeen`
- `Enable Remote Control? (y/n)`
- `Multi-session Remote Control is not enabled for your account yet.`
- `ProjectConfig.remoteControlSpawnMode`
- saved worktree preference fallback
- `--spawn=...`
- `spawnModeSource`
- gate default

## 第一性原理

standalone remote-control 的“这次到底以什么模式启动”至少沿着四条轴线分化：

1. `Consent Layer`：用户有没有先完成一次性的说明/同意。
2. `Eligibility Layer`：当前账号是否允许进入 multi-session 路径。
3. `Preference Layer`：这个项目此前是否记住了 same-dir / worktree 偏好。
4. `Effective Mode Layer`：本次启动最后真正落成的是 `single-session`、`same-dir`，还是 `worktree`。

因此更稳的提问不是：

- “standalone remote-control 的默认模式到底是什么？”

而是：

- “这次我看到的是一次性 consent、账号资格、项目偏好，还是最终 effective mode；它们里哪一个只是前提，哪一个真的决定了这次会怎么跑？”

只要这四条轴线没先拆开，正文就会把一次性说明、资格 gate、项目 preference 与 effective `spawnMode` 写成同一个“默认”。

这里还要主动卡住一个边界：

- 这页只处理 `registerBridgeEnvironment(...)` 之前的本地决议层
- 后端注册失败、资格不可用与 startup verdict 继续留给别页处理

## 第一层：`remoteDialogSeen` 解决的是一次性说明，不是 spawn mode 决策

### 这层只回答“是否先解释 remote-control 是什么”

`bridgeMain.ts` 在 resolve auth 之后，会检查：

- `getGlobalConfig().remoteDialogSeen`

如果没有，就弹出一段一次性说明：

- remote-control 允许你从 Web / app 接入当前 CLI session
- 以后也可以通过 `/remote-control` 断开
- 然后询问 `Enable Remote Control? (y/n)`

用户一旦走过这步，就会把：

- `remoteDialogSeen = true`

写回 global config。

这说明这里回答的问题不是：

- 当前项目到底该落 same-dir 还是 worktree

而是：

- 用户是否已经接受过 standalone remote-control 的 first-run explanation

### 所以这层和 project spawn preference 不是同一种“记住”

更准确的区分是：

- `remoteDialogSeen`：一次性 global consent memory
- `remoteControlSpawnMode`：项目级 spawn preference

只要这一层没拆开，正文就会把：

- “我已经看过说明”
- “这个项目以后默认用 worktree”

写成同一种 remembered default。

## 第二层：multi-session gate 决定你有没有资格谈 preference，不是 preference 本身

### gate 关着时，saved preference 会被整层降权

`bridgeMain.ts` 先算：

- `multiSessionEnabled = await isMultiSessionSpawnEnabled()`

如果当前命令用了 multi-session 相关功能，但 gate 没开，就直接：

- 记 `tengu_bridge_multi_session_denied`
- `console.error('Multi-session Remote Control is not enabled for your account yet.')`
- `process.exit(1)`

而且更关键的是，后面加载 saved preference 时也写得很明确：

- 只有 gate 开着，才读取 `getCurrentProjectConfig().remoteControlSpawnMode`
- gate 关掉时，saved preference 被整体降成 `undefined`

这说明 gate 回答的问题不是：

- “项目上次选的是 same-dir 还是 worktree”

而是：

- “你当前有没有资格进入 multi-session decision tree”

### 所以 eligibility 与 preference 是先后层，不是并列设置项

更准确的理解应是：

- 先过账号资格 gate
- gate 过了，项目 preference 才有资格参与本次决策

只要这一层没拆开，正文就会把：

- 账号暂时没开 multi-session
- 项目上次记住了 worktree

误写成“两个互相打架的默认值”。

## 第三层：`ProjectConfig.remoteControlSpawnMode` 记录的是项目偏好，不是当前命令一定采用的模式

### 这份 preference 只在 multi-session path 下参与，并且会被显式覆盖

`utils/config.ts` 对这个字段的注释非常直接：

- `Spawn mode for claude remote-control multi-session. Set by first-run dialog or w toggle.`

而 `bridgeMain.ts` 里 effective mode 的 precedence 也写得很硬：

- `resume`
- explicit `--spawn`
- saved project pref
- gate default

这说明 `remoteControlSpawnMode` 回答的问题不是：

- “本次命令现在就一定这样跑”

而是：

- “如果本次没有 resume、没有显式 `--spawn`，这个项目倾向于这样跑”

### 所以 project preference 是候选输入，不是最终判决

更准确的区分是：

- preference：一个可被上层前置条件与当前命令覆盖的 remembered input
- effective `spawnMode`：这次启动真正采用的 mode

只要这一层没拆开，正文就会把：

- “配置里记着 worktree”
- “这次一定 worktree 启动”

写成同一个结论。

## 第四层：saved worktree preference fallback 说明 preference 还要经过 substrate 校验

### saved preference 不是无条件回放

`bridgeMain.ts` 里，如果读到：

- `savedSpawnMode === 'worktree'`

但当前：

- `!worktreeAvailable`

系统不会盲目继续使用，而是会：

- 打 warning
- 把 `savedSpawnMode` 置空
- 清掉 `ProjectConfig.remoteControlSpawnMode`

文案也非常明确：

- `Saved spawn mode is worktree but this directory is not a git repository. Falling back to same-dir.`

这说明 saved preference 回答的问题不是：

- “我上次选过，所以这次必须照做”

而是：

- “如果当前 substrate 仍然成立，可以作为本次决策输入”

### 所以 project preference 与 substrate reality 不是同一层

更准确的理解应是：

- preference 记住的是上次偏好
- substrate 校验判断当前目录还能不能兑现这个偏好

只要这一层没拆开，正文就会把：

- saved worktree pref
- current worktree availability

误写成同一种项目设置。

## 第五层：first-run spawn chooser 只在“有资格且有意义”时才生成新 preference

### 它不是每次启动都弹，也不是所有 standalone host 都会看到

`bridgeMain.ts` 触发 first-run chooser 的条件非常严格：

- `multiSessionEnabled`
- `!savedSpawnMode`
- `worktreeAvailable`
- `parsedSpawnMode === undefined`
- `!resumeSessionId`
- `process.stdin.isTTY`

满足时，才会询问：

- `[1] same-dir`
- `[2] worktree`

并把结果写回：

- `ProjectConfig.remoteControlSpawnMode`

这说明 chooser 回答的问题不是：

- “remote-control 的一切启动都要先选模式”

而是：

- “当账号资格、目录 substrate、交互能力和当前命令形态都允许时，要不要为这个项目生成第一份 saved preference”

### 所以 chooser 是 preference 生成面，不是 effective mode 本身

更准确的区分是：

- chooser：生成或更新项目 preference
- effective `spawnMode`：本次最终采用的 mode

只要这一层没拆开，正文就会把：

- “弹过 same-dir/worktree 对话框”
- “本次已经以 worktree 启动”

再次写成同一种事实。

## 第六层：effective `spawnMode` 才是当前这次真正生效的模式，而且 precedence 是有层级的

### 这次真正采用的 mode 由四层 precedence 决定

`bridgeMain.ts` 直接给出了 effective mode 的 precedence：

1. `resume` 时强制 `single-session`
2. 显式 `--spawn`
3. saved project pref
4. gate default

而 gate default 本身又继续分成：

- gate on -> `same-dir`
- gate off -> `single-session`

这说明源码真正签字的对象不是：

- consent
- eligibility
- preference

而是：

- 经过这些层层过滤后的 final `spawnMode`

### 所以 “gate default” 也不是固定常量，而是资格层投影到 effective mode 的结果

更准确的理解应是：

- `gate default` 本身就是资格层对 effective mode 的一层映射
- 它不是用户显式选择，也不是项目 preference

只要这一层没拆开，正文就会把：

- `same-dir` 作为 gate-on default
- 用户自己选了 same-dir

误写成同一种来源。

## 第七层：`resume` 之所以排第一，是因为 continuity recovery 优先级高于项目偏好

### resume 会把 multi-session decision tree 直接短路

只要：

- `resumeSessionId`

成立，`bridgeMain.ts` 就直接：

- `spawnMode = 'single-session'`
- `spawnModeSource = 'resume'`

也就是说，即便：

- gate 开着
- saved preference 是 `worktree`
- 当前目录也支持 worktree

只要你这次是在恢复一条已知 session，preference tree 就不再参与本次 final mode。

### 所以 continuity recovery 与 host policy 不是同一个决策层

更准确的区分是：

- resume：先保 one specific session continuity
- preference / gate default：为 future host behavior 选 mode

只要这一层没拆开，正文就会把：

- “项目默认 worktree”
- “这次 resume 为什么不是 worktree”

误写成“系统没尊重我的配置”。

## 第八层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | first-run standalone consent、multi-session gate denial、saved worktree pref warning + fallback、same-dir / worktree chooser、effective mode precedence 的用户结果 |
| 条件公开 | `ProjectConfig.remoteControlSpawnMode`、gate on 时 same-dir default / gate off 时 single-session default、resume 优先级高于 saved pref |
| 内部/实现层 | `spawnModeSource`、analytics 事件名、flush 1P logging 细节、TTY / readline 细节 |

这里尤其要避免两种写坏方式：

- 把所有 remembered state 写成一页“远控默认设置”
- 把 consent、eligibility、preference 与 final mode 写成同一层默认值

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `remoteDialogSeen` = `remoteControlSpawnMode` | 一个记说明是否看过，一个记项目 spawn preference |
| multi-session gate = 项目默认 mode | gate 只是决定你能不能进入 multi-session tree |
| saved worktree pref = 本次一定 worktree | preference 还要过 substrate 校验与 precedence |
| chooser 弹过 = 本次 effective mode 已确定 | chooser 只生成 project preference |
| gate default `same-dir` = 用户主动选了 same-dir | 一个是资格层默认，一个是显式/保存偏好 |
| 项目默认 worktree = resume 也该 worktree | resume 强制 short-circuit 到 `single-session` |

## 六个高价值判断问题

- 当前看到的是一次性 consent、账号资格、项目 preference，还是 final mode？
- 这层东西是在解释、筛选、记忆偏好，还是在真正签字当前 mode？
- 当前项目偏好是不是已经被 substrate reality 或当前命令覆盖了？
- 现在的 `same-dir` 是用户选的、saved pref，还是 gate default？
- 我是不是又把 resume 这种 continuity recovery 写成 host default？
- 我是不是又把多个 remembered state 混成了一个“remote-control 默认设置”？

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/utils/config.ts`
- `claude-code-source-code/src/components/RemoteCallout.tsx`
