# 安全工程门的类型学：为什么研究版源码真正的阶段门是Reality Gate、Admission Gate、Normalization Gate、Static Gate、Isolation Gate、Bundle Gate、Smoke Gate与Verification Gap Gate

## 1. 为什么在 `117` 之后还必须继续写“门的类型学”

`117-安全工程阶段门与退出标准` 已经回答了：

`每个迁移阶段都必须有 entry gate、exit criteria 与 forbidden shortcut。`

但如果继续追问，  
还会碰到一个更贴源码的问题：

`这些 gate 在仓库里究竟长什么样？`

因为只要 gate 还停留在：

1. Phase 0
2. Phase 1
3. Phase 2
4. Phase 3
5. Phase 4

这种宏观迁移层，  
它仍然更像：

`路线图语言`

而不是：

`源码触点语言`

而 Claude Code 这份研究版源码真正珍贵的地方恰恰在于：

`它已经把很多 gate 写进了 README、scripts、tsconfig 与 build pipeline。`

所以 `117` 之后必须继续补出的下一层就是：

`安全工程门的类型学`

也就是：

`把“阶段门”进一步压缩成一组源码里真实存在、各自有不同签字权限的 gate 类型。`

## 2. 最短结论

对这份仓库来说，  
真正的 gate 不是抽象名词，  
而是一组更细的、彼此不能互相冒充的门：

1. `Reality Gate`
2. `Admission Gate`
3. `Normalization Gate`
4. `Static Gate`
5. `Isolation Gate`
6. `Bundle Gate`
7. `Smoke Gate`
8. `Verification Gap Gate`

它们分别回答八种完全不同的问题：

1. 我们手里的对象到底是什么
2. 我们有没有资格进入正式工具链
3. 源码有没有先被正规化到当前构建语境
4. 当前静态视角下它是否通过检查
5. 变换是否被隔离在中间产物而没有污染研究源
6. 是否真的产出了 best-effort artifact
7. 这个 artifact 是否至少能最小启动
8. 到这一步为止，什么仍然没有被证明

所以这一章的最短结论是：

`阶段门若不继续细化成门的类型学，就仍然难以阻止“拿低级 gate 的通过结果去冒充高级结论”。`

再压成一句：

`不同 gate 签不同命题，低级 gate 不能替高级 gate 签字。`

## 3. 第一性原理：为什么 gate 必须分型

因为“通过了一个门”本身并不携带语义。  
真正重要的是：

`它到底证明了什么。`

例如：

1. `npm run check` 通过，证明的是“当前 tsconfig 视角下可通过静态检查”
2. `node dist/cli.js --version` 通过，证明的是“最小启动路径可运行”
3. `README` 与 `QUICKSTART` 明确写出 extracted / best-effort / internal-build boundary，证明的是“对象边界是什么”

这三件事都是真的，  
但它们绝不是同一层真相。

所以 gate 分型的第一性原理就是：

`每一道门都只能对自己权限范围内的命题签字。`

如果不分型，  
系统就会不断出现 overclaim：

1. 把 `Static Gate` 说成“语义正确”
2. 把 `Bundle Gate` 说成“完整编译成功”
3. 把 `Smoke Gate` 说成“行为正确”
4. 把 `Reality Gate` 遗忘后继续把仓库当完整 upstream

## 4. 八类 gate 与源码触点

## 4.1 `Reality Gate`：当前对象到底是什么

这是最上层的 gate。

它由：

1. `README.md:5-6`
2. `QUICKSTART.md:3-5,89-103`

共同签字。

它允许说的话只有：

1. 这是从 npm tarball 提取出的 research source
2. full rebuild 依赖 Bun 与内部构建配置
3. best-effort build 不等于 full-fidelity rebuild

它禁止说的话是：

1. 这是完整上游工程
2. 公开仓已经具备内部构建闭环
3. Node/esbuild 结果等价于 Bun/internal build 结果

所以 `Reality Gate` 不是构建前的小准备，  
而是整条工程链最上游的真相门。

## 4.2 `Admission Gate`：有没有资格进入正式工具链

它主要由：

1. `package.json:7-18`
2. `QUICKSTART.md:25-45`

签字。

它回答的是：

1. Node / npm 版本是否可用
2. `esbuild` / `typescript` 是否在位
3. 是否通过正式 `scripts` 进入流程

它禁止的捷径是：

1. 跳过 `package.json` scripts
2. 用零散命令替代仓库正式入口
3. 在未满足工具链前提时直接讨论高层验证

所以 `Admission Gate` 签的不是“仓库正确”，  
而只是：

`你被允许进入这条正式工具链。`

## 4.3 `Normalization Gate`：源码是否已被正规化到当前运行语境

它由：

1. `package.json:8-10`
2. `scripts/prepare-src.mjs:3-9,36-76,79-115`

签字。

它证明的是：

1. `bun:bundle` 已被替换到当前语境可接受的 stub
2. `MACRO.*` 已被落成运行时值
3. 缺失 declaration 已补齐

它不允许被拿去说成：

1. 上游源码本来就是这样
2. Bun compile-time semantics 已被完整复现
3. 规范化后源码就等于官方语义源码

所以 `Normalization Gate` 的本质是：

`让研究树获得进入当前 best-effort build/check 语境的资格。`

## 4.4 `Static Gate`：当前静态视角下是否通过检查

它由：

1. `package.json:10`
2. `tsconfig.json:8-9,16-18,28-35`

共同签字。

它允许说的话只有：

1. `prepare-src` 之后，当前 TS 配置下可以 `tsc --noEmit`
2. 静态边界当前只覆盖 `src` 与 `stubs`
3. `tests/` 还没有正式进入类型制度

它禁止说的话是：

1. 通过 `check` 就等于语义正确
2. 通过 `check` 就等于与 upstream 一致
3. 当前不存在的 `tests/` 已被静态系统覆盖

所以 `Static Gate` 只是静态门，  
不是行为门。

## 4.5 `Isolation Gate`：构建变换有没有污染研究源

它由：

1. `scripts/build.mjs:52-128`
2. `QUICKSTART.md:47-56`

签字。

这里最关键的不是 build 成没成功，  
而是作者显式做了：

1. `src -> build-src`
2. 在 `build-src` 上 transform
3. 再生成 entry wrapper

这意味着仓库承认：

`研究源与构建中间态不能混写。`

它禁止的捷径是：

1. 直接在 `src/` 上做 build-time surgery
2. 把中间态反写成研究源
3. 让后续分析无法区分“原始源码”与“构建方便化后的源码”

所以 `Isolation Gate` 守护的不是“能不能跑”，  
而是：

`研究对象的可追溯性。`

## 4.6 `Bundle Gate`：是否产出了 best-effort artifact

它由：

1. `scripts/build.mjs:130-220`
2. `QUICKSTART.md:58-87`

签字。

它允许说的话是：

1. 当前 best-effort bundle 已产出
2. 产物建立在 iterative stub + bundle 之上
3. 它明确受 Bun intrinsics 与 missing modules 限制

它禁止说的话是：

1. 这已经是官方等价构建
2. feature-gated missing modules 已被真实恢复
3. stub 成功就等于语义成功

所以 `Bundle Gate` 最容易被偷换。  
它证明的是：

`产物存在`

而不是：

`产物等价。`

## 4.7 `Smoke Gate`：artifact 是否至少能最小启动

它由：

1. `package.json:11`
2. `QUICKSTART.md:43-45`

签字。

它的权限非常窄：  
只签“最小可启动证据”。

它不签：

1. 功能正确
2. 权限正确
3. 安全正确
4. 与官方行为一致

所以 `Smoke Gate` 的哲学就是：

`能点亮，不等于能正确工作。`

## 4.8 `Verification Gap Gate`：到这里为止还没有被证明什么

这是最容易被忽视、却又最重要的一道门。

它由：

1. `package.json` 没有 test/verify script
2. `tsconfig` 未纳入 `tests/`
3. 本地检查 `.github dirs: 0`
4. 本地检查 `test/spec files: 0`

共同签字。

它不是负面注脚，  
而是一道正式的诚实门。

它要求系统显式承认：

1. 当前没有正式自动化验证出口
2. 当前没有 CI 宿主
3. build/check/smoke 不能冒充 verify

它禁止的 overclaim 是：

1. 把本地 best-effort build 当成 test substitute
2. 把 smoke run 当成 correctness proof
3. 把没有的 CI 写成“默认未来会有”的已决事实

## 5. 为什么 `Verification Gap Gate` 反而是最成熟的一道门

因为真正成熟的工程体系，  
不只会声明：

`我证明了什么`

还会声明：

`我还没有证明什么`

而在 extracted repo 里，  
这一点尤其关键。

因为只要没有这道门，  
前面的 Reality / Admission / Normalization / Static / Isolation / Bundle / Smoke  
就会不断被串起来，  
伪装成一条根本不存在的“完整验证链”。

所以 `Verification Gap Gate` 的作用就是：

`在最容易自我陶醉的地方，强制系统停下来。`

## 6. 从工程哲学看，这八类 gate 其实在保护八种不同主权

1. `Reality Gate` 保护对象定义主权
2. `Admission Gate` 保护工具链准入主权
3. `Normalization Gate` 保护语境转换主权
4. `Static Gate` 保护静态语义主权
5. `Isolation Gate` 保护研究源纯度主权
6. `Bundle Gate` 保护产物命名主权
7. `Smoke Gate` 保护最小启动语义主权
8. `Verification Gap Gate` 保护未证事实的诚实主权

所以门的类型学不是把 phase 再换一种说法，  
而是把：

`谁有资格对哪类命题签字`

这件事正式分配出来。

## 7. 苏格拉底式反思：如果把这些 gate 混为一谈，会出现什么错觉

可以继续追问八个问题：

1. 我们是不是在拿对象边界门的结论，去替构建正确性签字
2. 我们是不是在拿静态门的通过，去替行为门签字
3. 我们是不是在拿 bundle 成功，去替语义等价签字
4. 我们是不是在拿 smoke run，去替安全正确签字
5. 我们是不是在忽略 verification gap，却继续宣称“工程化已经闭环”
6. 我们是不是把 `build-src` 的中间态误当成研究源本体
7. 我们是不是忘了 extracted repo 的所有过门结果都受 Reality Gate 上限约束
8. 我们是不是在没有 tests / CI 的情况下，提前发出了制度完成的宣言

这些问题共同收敛到一句话：

`门一旦不分型，低级证明就会不断越权冒充高级结论。`

## 8. 一条硬结论

对这份 Claude Code 研究版源码来说，  
真正严谨的安全工程写法不是：

`只说“现在到了哪个 phase”，`

而是：

`明确说当前过的是哪一类 gate，这道 gate 只配证明什么，又绝不能越权证明什么。`

因为只有这样，  
这份研究才会真正具备：

`既能前进，又不误签字的工程纪律。`

