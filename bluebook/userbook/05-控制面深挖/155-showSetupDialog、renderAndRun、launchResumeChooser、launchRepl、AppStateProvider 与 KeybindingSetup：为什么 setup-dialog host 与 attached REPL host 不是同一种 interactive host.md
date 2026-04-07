# `showSetupDialog`、`renderAndRun`、`launchResumeChooser`、`launchRepl`、`AppStateProvider` 与 `KeybindingSetup`：为什么 setup-dialog host 与 attached REPL host 不是同一种 interactive host

## 用户目标

154 已经把 `claude assistant` 的入口拆成了：

- discovery
- install bootstrap
- chooser
- attach

但如果正文停在这里，读者又很容易顺手把另一层压平：

- install wizard 会弹一个对话框
- session chooser 也弹一个对话框
- `ResumeConversation` 也能弹交互式选择器
- attached assistant REPL 也还是在同一个 root 里 render

于是正文就会滑成一句：

- “这些都只是同一套 interactive host 里换了不同组件。”

这句不稳。

从当前源码看，这里至少有两类不同宿主：

1. setup-dialog host
2. attached/full REPL host

它们共享部分包装件，但生命周期、返回契约和 shutdown 方式并不一样。

## 第一性原理

比起直接问：

- “这些交互界面不都跑在终端里吗？”

更稳的提问是先拆五个更底层的问题：

1. 当前宿主是一个“等待结果返回”的 setup dialog，还是一个“长期运行直到退出”的 REPL？
2. 当前调用者等待的是一个 picker/wizard 的结果值，还是整个交互进程结束？
3. 当前包装件是 `showSetupDialog(...)`，还是 `renderAndRun(...)`？
4. 当前界面里有没有 `<App>` 顶层壳，还是只用 `AppStateProvider + KeybindingSetup`？
5. 如果 `launchResumeChooser` 明确写着 “Uses renderAndRun, NOT showSetupDialog”，那 chooser 类 UI 还能被写成同一种 setup host 吗？

这五问不先拆开，正文很容易把所有 terminal 交互都写成：

- “只是不同 JSX 的不同入口”

## 第一层：`showSetupDialog(...)` 定义的是“拿结果就返回”的 setup-dialog host

`interactiveHelpers.tsx` 里 `showSetupDialog(...)` 的注释已经把主语写死了：

- Show a setup dialog
- wrapped in `AppStateProvider + KeybindingSetup`
- reduces boilerplate

它的函数签名也进一步说明这类宿主的合同是：

- 调用者传一个 `done(result)` callback
- `showSetupDialog<T>` 最终 resolve 一个结果值

也就是说它首先回答的是：

- “展示一个一次性设置/选择对话框，并等待它把结果交回来”

不是：

- “把整个交互应用一直跑到用户退出”

所以 `showSetupDialog(...)` 这类宿主的第一性原理是：

- result-returning setup host

## 第二层：assistant install wizard 和 session chooser 都属于 setup-dialog host

`dialogLaunchers.tsx` 把这一层写得更清楚。

### `launchAssistantSessionChooser(...)`

这里：

- 动态导入 `AssistantSessionChooser`
- 通过 `showSetupDialog<string | null>(...)`
- 返回 picked id 或 `null`

它回答的问题是：

- 从候选 session 里选哪一个

### `launchAssistantInstallWizard(...)`

这里：

- 动态导入 `NewInstallWizard`
- 计算 `defaultDir`
- 通过 `showSetupDialog<string | null>(...)`
- 再和 `errorPromise` race

它回答的问题是：

- 安装成功目录是什么
- 用户取消了没有
- 安装内部报错了没有

这两个 launcher 虽然业务不同，但宿主合同一致：

- 都是 setup-dialog host
- 都返回一个结果值
- 都在结果出来后把控制权交回调用者

所以 install wizard 和 assistant chooser 共享的是：

- host family

不是：

- attach REPL contract

## 第三层：`renderAndRun(...)` 定义的是“渲染主 UI 并等它退出”的长期宿主

同一个 `interactiveHelpers.tsx` 里，`renderAndRun(...)` 则是另一种完全不同的合同。

它做的事情是：

1. `root.render(element)`
2. `startDeferredPrefetches()`
3. `await root.waitUntilExit()`
4. `await gracefulShutdown(0)`

这和 `showSetupDialog(...)` 的差别非常本质。

它不再回答：

- 某个 picker 返回了什么

而是在回答：

- 这个 interactive app 什么时候真正结束

所以 `renderAndRun(...)` 的主语更像：

- long-lived interactive host

不是：

- result-returning setup host

## 第四层：`launchRepl(...)` 用 `renderAndRun(...)` 跑 `<App><REPL/>`，所以 attach REPL 属于长期宿主

`replLauncher.tsx` 把这层说得更直白：

- 动态导入 `App`
- 动态导入 `REPL`
- `await renderAndRun(root, <App ...><REPL ... /></App>)`

也就是说 attached assistant REPL、`--remote` TUI、direct connect REPL 这些路径，虽然业务不同，但宿主合同是一致的：

- `<App>` 顶层壳
- `<REPL>` 长期运行
- 直到 root 退出才收口

所以 attach REPL 并不是：

- “某个 setup dialog 选完以后顺手停留在屏幕上的后续状态”

而是：

- 另一类 host family

## 第五层：`launchResumeChooser(...)` 证明“选择器”本身也可能属于 REPL-style host，而不属于 setup-dialog

这页最容易漏掉的关键对照就在 `dialogLaunchers.tsx` 注释里：

- `launchResumeChooser(...)`
- Uses `renderAndRun`, NOT `showSetupDialog`
- Wraps in `<App><KeybindingSetup>`

这意味着“是否是 chooser/picker”并不能决定宿主类型。

更准确地说：

### assistant session chooser

- chooser 业务
- setup-dialog host

### resume chooser

- 也是 chooser/picker 业务
- 但宿主是 `renderAndRun(...)` + `<App>` 的长期交互壳

这一步特别重要，因为它说明：

- 宿主类型的分界线不在“是不是选择器”

而在：

- 是不是 result-returning dialog contract
- 还是 full interactive app contract

## 第六层：`AppStateProvider + KeybindingSetup` 与 `<App>` 不是同一层壳

如果只看包装件，又很容易再犯一个错：

- setup dialog 有 `AppStateProvider + KeybindingSetup`
- resume chooser 有 `<App><KeybindingSetup>`
- attached REPL 也有 `<App>`

于是顺手把这些写成：

- 同一套壳拆成不同组合

当前源码更稳的写法是：

### setup-dialog host

- 由 `showSetupDialog(...)` 统一包装
- 最小交互壳是 `AppStateProvider + KeybindingSetup`
- 目标是等 `done(result)`

### REPL / full interactive host

- 由 `renderAndRun(...)` 统一收口
- 典型壳是 `<App>...`
- 目标是跑到 `root.waitUntilExit()`

所以虽然：

- `KeybindingSetup`

会在两类宿主里都出现，

但它们不因此就变成同一种 host。

## 稳定面与灰度面

### 稳定面

- `showSetupDialog(...)` 是 result-returning setup host
- `launchAssistantInstallWizard(...)` / `launchAssistantSessionChooser(...)` 属于 setup-dialog host
- `renderAndRun(...)` 是长期 interactive host
- `launchRepl(...)` 明确把 REPL 装进 `<App>` 并交给 `renderAndRun(...)`
- `launchResumeChooser(...)` 证明 chooser 类 UI 也可能属于 REPL-style host，而不是 setup-dialog host

### 灰度面

- 某些未来新增 chooser/wizard 会落在哪个 host family
- setup dialog 是否会继续增加更多统一包装层
- `<App>` 壳内部未来会不会继续收纳更多 interactive-only provider

## 为什么这页不是 154

154 讲的是：

- discovery
- install
- chooser
- attach

这是一条业务入口链。

155 讲的是：

- 这些步骤到底跑在什么 host family 里
- 为什么 setup-dialog host 和 attached/full REPL host 不能混写

所以 154 的主语是：

- flow segmentation

155 的主语是：

- host contract segmentation

## 苏格拉底式自审

### 问：为什么 install wizard 和 assistant chooser 不能直接算“attach 前两步 UI”？

答：因为它们都走 `showSetupDialog(...)`，等待 `done(result)` 返回后就把控制权交回调用者；attach REPL 则走 `renderAndRun(...)`，宿主合同完全不同。

### 问：为什么一定要把 `launchResumeChooser(...)` 拉进来？

答：因为它是最干净的反例，说明“chooser/picker”这个业务标签并不能决定宿主类型。

### 问：为什么一定要把 `replLauncher.tsx` 写进来？

答：因为只有把 `launchRepl(...) -> renderAndRun(<App><REPL/>)` 写出来，attached REPL host 才不是只靠 `main.tsx` 调用点推断。

### 问：这页的一句话 thesis 是什么？

答：`showSetupDialog(...)` 和 `renderAndRun(...)` 代表两类不同的 interactive host：前者是返回结果的 setup-dialog，后者是长期运行的 `<App>/<REPL>` 宿主；assistant install/chooser 与 attached REPL 共用终端，但不共用同一种 host contract。

## 结论

对当前源码来说，更准确的写法应该是：

1. `showSetupDialog(...)` 定义的是 result-returning setup-dialog host
2. assistant install wizard 和 session chooser 都属于 setup-dialog host
3. `renderAndRun(...)` 定义的是长期 interactive host
4. `launchRepl(...)` 明确把 attached/full REPL 装进 `<App>` 并交给 `renderAndRun(...)`
5. `launchResumeChooser(...)` 证明 chooser/picker 业务并不自动等于 setup-dialog host

所以：

- setup-dialog host 与 attached REPL host 不是同一种 interactive host

## 源码锚点

- `claude-code-source-code/src/interactiveHelpers.tsx`
- `claude-code-source-code/src/dialogLaunchers.tsx`
- `claude-code-source-code/src/replLauncher.tsx`
- `claude-code-source-code/src/main.tsx`
