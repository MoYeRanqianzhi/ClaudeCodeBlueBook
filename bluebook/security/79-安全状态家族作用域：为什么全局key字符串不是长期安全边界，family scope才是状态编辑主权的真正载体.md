# 安全状态家族作用域：为什么全局key字符串不是长期安全边界，family scope才是状态编辑主权的真正载体

## 1. 为什么在 `78` 之后还要继续写“状态家族作用域”

`78-安全状态编辑主权` 已经回答了：

`状态编辑动词之后，还必须继续追问主语。`

但如果继续往下追问，  
还会碰到一个更接近接口设计、也更接近长期演化风险的问题：

`这个主语现在到底被编码在哪里？`

从源码看，  
答案并不是：

`在类型系统里`

也不是：

`在 capability handle 里`

而更多是：

`在 key 命名习惯里。`

也就是说，  
当前系统实际上在依赖一层隐含结构：

`status family`

比如：

1. `ide-status-*`
2. `fast-mode-*`
3. `mcp-*`
4. `teammate-*`
5. `external-editor-*`

这些前缀本质上都在说：

`这几条状态是一家人。`

所以在 `78` 之后，  
安全专题必须再补一条更底层的原则：

`状态家族作用域。`

也就是：

`真正支撑状态编辑主权的，不该只是全局 string key，而应是“这个 key 属于哪个状态家族、该家族的作用域边界在哪里”。`

## 2. 最短结论

从源码看，Claude Code 当前已经明显在使用 family scope，只是它还没有被正式建模：

1. `notifications` 上下文对状态身份、fold、去重、失效和删除的判断，全部只看全局 `key` 字符串  
   `src/context/notifications.tsx:45-76,121-185,193-213,236-239`
2. 但业务代码里的 key 又明显不是随机命名，而是在用前缀隐含 family，例如 `fast-mode-*`、`ide-status-*`、`teammate-*`  
   `src/hooks/notifs/useFastModeNotification.tsx:8-11`  
   `src/hooks/notifs/useIDEStatusIndicator.tsx:88-149`  
   `src/hooks/notifs/useTeammateShutdownNotification.ts:24-45`
3. `settings-errors` 这类常驻状态也被先提升为本地常量，再由同一 hook 使用，说明作者已经在手工维护“本家 key”  
   `src/hooks/notifs/useSettingsErrors.tsx:8-14`
4. `external-editor-error` 在同一 PromptInput 子系统里被两个分支复用同一个 key，说明 key 在这里承担的是“家族身份”，而不只是“某一次消息实例”  
   `src/components/PromptInput/PromptInput.tsx:1328-1349`
5. 这说明当前代码现实不是没有 scope，而是：

`scope 被隐含进了命名规则与文件边界。`

所以这一章的最短结论是：

`Claude Code 已经在按状态家族思考，但 family scope 还停留在约定层，没有升级成接口层。`

我把它再压成一句：

`现在真正扛着编辑主权的，是 key 前缀；这在工程上够用，但还不够稳。`

## 3. 源码已经说明：family scope 目前主要藏在 key 命名里

## 3.1 `notifications` context 根本不知道 family，只知道全局 key 相等

`src/context/notifications.tsx:45-76,121-185,193-213,236-239` 很关键。

这里通知系统对状态的所有核心操作都基于：

1. `prev.notifications.current?.key === ...`
2. `findIndex(_ => _.key === notif.key)`
3. `queuedKeys.has(notif.key)`
4. `filter(n => n.key !== key)`

也就是说：

1. 身份判断靠 key
2. fold 命中靠 key
3. 去重靠 key
4. remove 靠 key
5. invalidates 最终还是按 key 清理

在这个抽象层里，  
系统并不知道：

1. 这是 IDE family
2. 这是 fast mode family
3. 这是 teammate family

它只知道：

`这是某个全局字符串。`

这正是本章的问题起点。

## 3.2 但业务层显然已经在用 key 前缀手工编码 family scope

`src/hooks/notifs/useFastModeNotification.tsx:8-11` 明确把一组 key 命名成：

1. `fast-mode-cooldown-started`
2. `fast-mode-cooldown-expired`
3. `fast-mode-org-changed`
4. `fast-mode-overage-rejected`

`src/hooks/notifs/useIDEStatusIndicator.tsx:88-149` 又把另一组 key 命名成：

1. `ide-status-disconnected`
2. `ide-status-jetbrains-disconnected`
3. `ide-status-install-error`
4. `ide-status-hint`

`src/hooks/notifs/useTeammateShutdownNotification.ts:24-45` 则继续是：

1. `teammate-spawn`
2. `teammate-shutdown`

这说明作者其实并不是在随便起名字。  
他们已经在用 key 前缀表达一个隐含事实：

`这些状态属于同一治理域。`

换句话说，  
family scope 在现实里已经存在，  
只是还没有被抽出来。

## 3.3 本地常量的出现，说明作者已经意识到“这不是任意字符串”

`src/hooks/notifs/useSettingsErrors.tsx:8-14` 很值得写进来。

这里不是每次都内联：

`"settings-errors"`

而是先定义：

`SETTINGS_ERRORS_NOTIFICATION_KEY`

然后在同一 hook 里 add / remove。

这说明作者已经隐约意识到：

`这个 key 不是随手写的文案标签，而是一个需要被稳定引用的家族成员。`

同样地，  
fast mode 也是先定义 family constants 再使用。

因此当前系统虽然没有显式 scope type，  
却已经在通过常量化表达：

`key 应当具有家族内稳定身份。`

## 3.4 `external-editor-error` 的复用说明：同一家族可以有多条入口，但应共享同一作用域身份

`src/components/PromptInput/PromptInput.tsx:1328-1349` 非常有代表性。

这里：

1. 编辑器返回业务错误时，发 `external-editor-error`
2. try/catch 真异常时，也发 `external-editor-error`

这说明这两个分支虽然是两种触发路径，  
却被明确建模成：

`同一个状态家族下的同一个身份槽位`

作者显然不想让它们变成两条并列错误通知。  
他们希望用户看到的是：

`当前 external editor error`

而不是：

`某个分支 A 的 error + 某个分支 B 的 error`

这进一步说明 key 的真实作用不是消息 ID，  
而是：

`作用域内的状态槽位名。`

## 3.5 第一性原理：真正的主权边界从来不是名字本身，而是名字背后的作用域

如果从第一性原理追问：

`为什么光有 key 名称不够？`

因为名字本身不构成边界。  
它最多只是边界的记号。

真正构成边界的是：

1. 这个 key 属于哪个 family
2. 这个 family 的 owner 是谁
3. 这个 family 允许哪些编辑动词
4. 这个 family 与其他 family 的关系是什么

如果这些都没被正式编码，  
那 key 再起得像：

`ide-status-*`

也仍然只是：

`靠约定维持的边界。`

一旦代码规模继续变大，  
或者宿主、插件、远程适配层继续增加，  
这种边界最容易退化成：

`字符串前缀看起来像有作用域，实际上谁都能碰。`

## 3.6 技术先进性与改进方向：Claude Code 已经有 namespace discipline，但还没有 family-scoped capability

从技术角度看，  
Claude Code 当前方案已经比很多系统成熟：

1. key 前缀明显在表达家族
2. family constants 已经出现在一些关键子系统里
3. 真实编辑行为大多仍局限在本子系统内部

这说明它已经有：

`namespace discipline`

但如果从下一代安全控制台标准看，  
它仍缺少更强的一层：

`family-scoped capability`

也就是：

1. 不是传裸 `string key`
2. 而是传 family handle
3. 再由 family handle 派生可编辑的成员
4. 并在接口层限制 outsider 越权

这将把当前的：

`命名约定`

提升成：

`可被接口验证的作用域边界`

## 4. 状态家族作用域的最短规则

把这一章压成最短规则，就是下面六句：

1. 全局 key 只能表达身份，不能单独表达边界
2. 真正的边界来自 status family
3. key 前缀可以提示 family，但不应成为长期唯一载体
4. family 内部可以共享状态槽位，但应由同一 owner 管理
5. family 之间的编辑越界不应只靠命名自觉防止
6. 下一代接口应当把 family scope 显式化，而不是继续隐藏在 key 字符串里

## 5. 苏格拉底式追问：这套系统还能怎样再向前推进

如果继续自问，  
最值得做的三项演进会是：

1. 给 `Notification.key` 增加 family declaration，而不是只保留裸名字
2. 让 `remove`、`invalidate`、`fold` 默认在 family scope 内解析，而不是全局解析
3. 给统一安全控制台增加 family map，使 UI、协议与宿主适配共享同一套作用域账本

所以这一章最终沉淀出的设计启示是：

`真正稳固的状态主权，不该只靠好命名，而要靠被显式承认的作用域。`
