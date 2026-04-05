# 安全工程结论签字权：为什么不同源码触点只能签不同强度的结论，而不能把README、check、bundle与smoke混成同一种“已验证”

## 1. 为什么在 `118` 之后还必须继续写“结论签字权”

`118-安全工程门的类型学` 已经回答了：

`不同 gate 其实在对不同命题签字，低级 gate 不能越权冒充高级结论。`

但如果继续追问，  
还会碰到一个更严厉、也更接近写作纪律的问题：

`既然不同 gate 不能互相冒充，那每一种源码触点到底最多只能支持到哪一级结论？`

因为只要这个问题没有继续收紧，  
文档作者、维护者、评审者仍然很容易犯同一种错误：

1. 看见 `README` 的边界说明，就顺手把它写成产品能力上限
2. 看见 `npm run check` 通过，就顺手把它写成“语义正确”
3. 看见 `dist/cli.js --version` 可跑，就顺手把它写成“构建已验证”
4. 看见本地没有 `tests/CI`，却又在另一段文字里默认“工程化闭环已经存在”

所以 `118` 之后必须继续补出的下一层就是：

`安全工程结论签字权`

也就是：

`不同源码触点不仅对应不同 gate，还各自有严格的结论上限；超出这个上限的句子，就是 overclaim。`

## 2. 最短结论

对这份研究版 Claude Code 源码来说，  
最危险的工程失真不是“证据不够多”，  
而是：

`证据说得太满。`

从当前源码触点看：

1. `README.md:72-74,190-193` 只能签“源码不完整、缺失模块不可由公开产物恢复”
2. `package.json:7-11` 只能签“仓库正式承认了哪些 scripts 入口”
3. `prepare-src.mjs:3-9,79-115` 只能签“源码已被规范化到当前 best-effort 语境”
4. `tsconfig.json:8-9,16-18,28-35` 与 `check` 只能签“当前静态视角下可通过检查，且覆盖边界有限”
5. `build.mjs:52-170` 只能签“research source 已经被隔离、转换并产出 best-effort bundle”
6. `QUICKSTART.md:43-45` 与 `start` 只能签“最小启动证据成立”
7. 本地检查 `.github dirs: 0`、`test/spec files: 0` 只能签“当前正式验证与自动化宿主缺失”

所以这一章的最短结论是：

`安全工程真正高级的地方，不是把所有证据堆成一个“已验证”，而是给每类证据设定明确的 claim ceiling。`

再压成一句：

`证据越多不一定越真；证据说得刚好，才是真。`

## 3. 第一性原理：什么叫“结论签字权”

所谓结论签字权，  
本质上是在回答：

`这份证据最多能证明到哪一步。`

它不是证据有没有价值的问题，  
而是证据有没有被滥用的问题。

例如：

1. `README` 的价值是定义对象边界
2. `script` 的价值是定义正式入口
3. `prepare-src` 的价值是定义语境归一化
4. `check` 的价值是定义静态通过
5. `build` 的价值是定义 best-effort artifact existence
6. `smoke` 的价值是定义最小启动
7. gap 检查的价值是定义“未证明部分”

每一项都有价值，  
但每一项都只在自己的权限范围内有价值。

所以结论签字权的第一性原理就是：

`一份证据的真实价值，不在于它能说多少，而在于它知道自己不能说什么。`

## 4. 不同源码触点各自的 claim ceiling

## 4.1 `README` 的签字权：对象边界，不是产品等价

`README.md:72-74` 已经写得很硬：

1. source is incomplete
2. 108 模块不在 npm package 中
3. 它们不能从公开 artifact 恢复

`README.md:190-193` 又再次钉死：

1. `feature()` 是 compile-time intrinsic
2. 108 模块在 published artifact 里根本不存在

所以 `README` 最强只能签：

`对象边界`

也就是：

1. 我们现在研究的是一个不完整的公开提取树
2. 它有明确的不可恢复缺口

它绝不能被拿去签：

1. 当前构建一定能跑到什么程度
2. 当前 runtime 行为与上游一致
3. 只要继续补代码就能还原完整产品

换句话说：

`README` 签的是“这是什么”，不是“它现在能做到什么”。`

## 4.2 `package.json` 的签字权：正式入口，不是工程闭环

`package.json:7-11` 当前只正式承认：

1. `prepare-src`
2. `build`
3. `check`
4. `start`

这说明仓库正式制度目前覆盖的是：

1. 预处理
2. 构建
3. 静态检查
4. 启动

所以 `package.json` 最强只能签：

`当前仓库有哪些被正式承认的工程入口`

它不能被拿去签：

1. 已有完整 verify/test 制度
2. 已有 CI 契约
3. 已有 pre-merge gate

因为这些入口在文件里根本不存在。

所以 `package.json` 的哲学是：

`声明存在的入口，不替不存在的制度背书。`

## 4.3 `prepare-src` 的签字权：语境正规化，不是语义复原

`scripts/prepare-src.mjs:3-9` 写得很明确：

1. patch `bun:bundle`
2. patch `MACRO.*`
3. create missing type declarations

`scripts/prepare-src.mjs:79-115` 又表明这确实是一个会修改后续参与者语境的前置步骤。

所以它最强只能签：

`源码已被归一化到当前 Node/best-effort build-check 语境。`

它绝不能签：

1. Bun compile-time semantics 已被完整复原
2. prepare 后源码等价于 Anthropic 内部构建视角源码
3. 所有 feature-gated 分支都被正确恢复

所以 `prepare-src` 的 claim ceiling 是：

`语境可参与，不等于语义等价。`

## 4.4 `check + tsconfig` 的签字权：静态可通过，不是行为正确

`tsconfig.json:8-9` 还明确写了：

1. `strict: false`
2. `skipLibCheck: true`

`tsconfig.json:16-18,28-35` 又写了：

1. `rootDir = src`
2. `include = src/**/*, stubs/**/*`

所以 `npm run check` 通过，  
最强只能签：

1. 当前静态配置下可通过 `tsc --noEmit`
2. 覆盖视角仅限 `src` 与 `stubs`
3. 这不是一个高强度、全覆盖、严格模式的静态证明

它绝不能签：

1. 运行时行为正确
2. 缺失模块影响已消除
3. 未来 `tests/` 骨架也被当前类型制度自动守护

所以 `Static Gate` 的结论上限必须被明确写成：

`静态通过`

而不是：

`系统正确。`

## 4.5 `build.mjs` 的签字权：best-effort artifact existence，不是 full-fidelity rebuild

`scripts/build.mjs:52-170` 明确把构建写成：

1. copy source
2. transform
3. create entry
4. iterative stub + bundle

`QUICKSTART.md:58-66` 又明确强调：

1. Bun intrinsics 不能被完全复现
2. 108 missing modules 仍是硬缺口

所以 `build` 最强只能签：

1. best-effort artifact 已产出
2. 研究源与构建中间态已隔离
3. 这条 artifact 建立在 transform + stub 的受限条件上

它绝不能签：

1. 已完成官方等价构建
2. 语义与内部 Bun 构建一致
3. 特性缺口已被真实消除

所以 `build` 的结论上限不是：

`产品构建成功`

而是：

`受限条件下的 best-effort bundle 存在。`

## 4.6 `smoke` 的签字权：最小启动，不是功能/安全验证

`QUICKSTART.md:43-45` 只说：

1. if successful, run the output
2. `node dist/cli.js --version`

`package.json:11` 也只把 `start` 定义为：

`node dist/cli.js`

所以 `smoke` 最强只能签：

`最小启动证据成立`

它不能签：

1. 完整功能正确
2. 权限模式正确
3. 安全控制面正确
4. 与官方发布行为一致

这就是为什么高级安全工程里，  
`can launch` 必须与 `is correct` 分开写。

## 4.7 gap 检查的签字权：未证事实的诚实声明

本地检查结果非常简单：

1. `.github dirs: 0`
2. `test/spec files: 0`

它最强只能签：

1. 当前仓内没有显式 CI 宿主
2. 当前仓内没有显式 tests 入口与 conventional test corpus
3. 到这一步为止，正式验证闭环仍然不存在

它也不能被滥用：

1. 不能因为本地没看到，就断言外部世界不存在别的验证
2. 但同样不能在当前仓内证据缺失时，假装这里已经有验证制度

所以 gap 检查的哲学不是悲观，  
而是：

`对未证事实保持诚实。`

## 5. 技术先进性：真正先进的安全工程，会把 claim ceiling 写进系统

很多工程团队会把先进性理解成：

1. 检测器更多
2. 护栏更多
3. 自动化更多

但从第一性原理看，  
真正更高级的系统还有第四层能力：

`控制系统自己说话的强度。`

也就是：

1. 哪类证据最多只配得出哪类结论
2. 哪类证据必须与别的证据联立后才能升级结论
3. 哪些更强句子在当前证据下必须被禁止

从这个角度看，  
这份 Claude Code 研究版源码最值得借鉴的技术启示不是单点脚本，  
而是它已经隐含地把这些层级写出来了：

1. `README` 负责对象边界
2. `scripts` 负责工程入口
3. `prepare-src` 负责语境正规化
4. `check` 负责静态视角
5. `build` 负责产物生成
6. `smoke` 负责最小启动
7. 缺失 tests/CI 则负责把未证部分保留下来

这是一种：

`把结论强度分层治理`

的安全工程思路。

## 6. 如果不写 claim ceiling，会发生什么系统性错误

最常见的会有六种：

1. `README overclaim`
   把边界说明误写成能力声明。
2. `script overclaim`
   把入口存在误写成制度闭环。
3. `prepare overclaim`
   把语境归一化误写成语义复原。
4. `check overclaim`
   把静态通过误写成运行时正确。
5. `build overclaim`
   把 best-effort artifact 误写成官方等价构建。
6. `smoke overclaim`
   把最小启动误写成功能与安全验证。

这些错误的共同结构都一样：

`弱证据冒充强结论。`

而这正是安全工程最该防的失真之一。

## 7. 苏格拉底式反思：如果我要把一句话写进蓝皮书，先该怎样质问自己

可以先追问八句：

1. 这句话到底是哪一类证据签的字
2. 这份证据是否真的拥有签这句话的权限
3. 我是不是把“存在”写成了“正确”
4. 我是不是把“可跑”写成了“已验证”
5. 我是不是把“静态通过”写成了“语义成立”
6. 我是不是把“缺失尚未证明”偷偷写成了“未来自然会补齐”
7. 如果换一个更保守的表述，这句话会失去什么
8. 如果一句话必须靠多个证据联立才成立，我现在是否只拿了其中一个

这些追问最终会逼出一条最重要的写作纪律：

`每一句结论都必须能回溯到它真正的签字人。`

## 8. 一条硬结论

对这份 Claude Code 研究版源码来说，  
真正成熟的安全研究写法不是：

`把看到的所有正向信号压成一个“已验证”，`

而是：

`明确写出每类源码触点的 claim ceiling，并禁止它越权支持更强结论。`

因为只有这样，  
这份蓝皮书才不会变成：

`证据很多，但结论失真`

而会进一步升级成：

`证据、签字权与结论强度严格对齐的安全工程研究。`

