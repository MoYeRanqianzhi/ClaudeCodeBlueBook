# 安全工程阶段门与退出标准：为什么每个迁移阶段都必须有明确的entry gate、exit criteria与禁止越级推进

## 1. 为什么在 `116` 之后还必须继续写“阶段门”

`116-安全工程迁移路线图` 已经回答了：

`这份研究版源码若要走向可持续安全工程，必须按阶段迁移，而不能一次性重构。`

但如果继续追问，  
还会碰到一个更严厉的问题：

`既然已经有 phase，为什么还不够？`

答案是：

`因为“有阶段”不等于“有阶段门”。`

如果一个 phase 只有名字、没有 entry gate、没有 exit criteria、没有 forbidden shortcut，  
那它仍然只是：

`顺序化叙事`

而不是：

`可执行约束`

所以 `116` 之后必须继续补出的下一层就是：

`安全工程阶段门与退出标准`

也就是：

`每个迁移阶段都必须明确回答：什么前提下才准进入、什么条件下才算完成、什么越级动作必须被禁止。`

## 2. 最短结论

从这份仓库当前的源码与结构看，  
安全工程若没有阶段门，最容易发生的不是“推进太慢”，  
而是“错误越级”：

1. `README.md` 已明确这是一份 extracted research repo，不是完整上游工程  
   `README.md:5-6`
2. `QUICKSTART.md` 已明确 full rebuild 依赖 Bun compile-time intrinsics，best-effort build 仍受 feature-gated missing modules 约束  
   `QUICKSTART.md:3-5,60-70,89-103`
3. `package.json` 只有 `prepare-src/build/check/start`，说明 build/check 已有制度入口，但 test/verify 仍未建立  
   `package.json:7-11`
4. `prepare-src.mjs` 明确把预处理写成所有后续流程的前置动作  
   `scripts/prepare-src.mjs:3-9,79-115`
5. `build.mjs` 已把构建流程写成显式 phase pipeline，说明作者认可“先过前置门，再进入下一步”  
   `scripts/build.mjs:3-18,52-170`
6. `tsconfig.json` 的 `rootDir=src` 且 `include` 仅覆盖 `src/**/*` 与 `stubs/**/*`，说明任何 `tests/` 骨架都不会自动被现有类型制度承接  
   `tsconfig.json:16-18,28-35`
7. 本地检查显示 `.github dirs: 0`、`test/spec files: 0`，说明自动执行宿主与验证目录都尚未形成

所以这一章的最短结论是：

`这份仓库当前真正缺的不是“更多 phase 名称”，而是把每个 phase 写成一条带有准入门、退出门与禁止捷径的工程宪法。`

再压成一句：

`阶段门的本质，不是控制速度，而是控制误压缩。`

## 3. 第一性原理：阶段门到底在防什么

不是防拖延。  
也不是防官僚。

它真正防的是：

`把局部理解过早压缩成全局约束。`

这在研究版 extracted repo 里尤其危险。

因为这里最容易犯的错误不是“什么都没做”，  
而是：

1. 误把局部证据当成全局真相
2. 误把研究假说当成制度接口
3. 误把能跑通一次的脚本当成长期可执行契约
4. 误把缺失宿主的本地约束当成自动化门槛

所以阶段门的真正哲学不是：

`把事情分成几步做`

而是：

`只有当某一层的不确定性已经被压缩到足够低，才允许进入外部性更高的下一层。`

研究可以容忍开放问题；  
制度不能容忍伪确定性。

## 4. 源码已经在提醒我们：这份仓库天然需要“阶段门”

## 4.1 `package.json` 已经把“前置门”写进脚本依赖关系

`package.json:7-11` 非常关键：

1. `build` 不是直接执行 `build.mjs`，而是先 `npm run prepare-src`
2. `check` 也不是裸 `tsc --noEmit`，而是先 `npm run prepare-src`

这说明作者已经在用脚本依赖关系表达一个事实：

`没有先过 prepare gate，就没有资格进入 build/check。`

所以未来安全验证若要制度化，  
最自然的延伸不是另起一套哲学，  
而是继续沿用：

`先回答前置门，再谈执行门。`

## 4.2 `prepare-src.mjs` 表明“预处理是否完成”本身就是 entry gate

`scripts/prepare-src.mjs:3-9` 直接写出它的职责：

1. 处理 `bun:bundle`
2. 处理 `MACRO.*`
3. 生成缺失 type declaration

而 `scripts/prepare-src.mjs:79-115` 又表明这不是局部 hack，  
而是会遍历源码并写入补丁结果。

这意味着未来任何 verify/test 制度若不先回答：

`它是验证原始树，还是验证 prepare 之后的树？`

那它的 entry gate 就根本没有被定义。

## 4.3 `build.mjs` 本身就是一个显式 phase system

`scripts/build.mjs:52-170` 已经写出：

1. Phase 1 copy
2. Phase 2 transform
3. Phase 3 entry wrapper
4. Phase 4 iterative stub + bundle

这说明作者并不是把流程理解成“一条平面命令”，  
而是理解成：

`上一阶段产物构成下一阶段准入条件。`

如果 build 自己都已经依赖 phase gate，  
安全工程迁移就更不应只停在抽象口号。

## 4.4 `tsconfig.json` 又暴露了当前真正的 scope gate

`tsconfig.json:16-18,28-35` 的含义很硬：

1. 当前类型制度的主权边界是 `src`
2. `stubs` 被视为正式参与者
3. `tests` 目前并不在体制内

这就是典型的 scope gate。  
任何人若想直接写“测试已接入工程体系”，  
都必须先回答：

`测试到底如何进入当前类型和路径制度。`

## 4.5 `README.md` 与 `QUICKSTART.md` 定义了最上层的 repo-boundary gate

`README.md:5-6` 已明确这是从 npm tarball 提取出的研究版源码。  
`QUICKSTART.md:3-5,60-70,89-103` 又明确 full rebuild 需要 Bun 与内部构建配置，  
best-effort build 仍受 missing modules 制约。

这意味着任何阶段门如果不先承认：

`当前对象不是完整 upstream，而是 research-extracted / feature-incomplete 的中间态对象`

那后续所有 exit criteria 都会失真。

## 4.6 没有 `.github/` 与 `tests/`，说明自动化阶段还没有资格成立

本地检查结果：

1. `.github dirs: 0`
2. `test/spec files: 0`

这不是小瑕疵。  
它意味着两个 gate 都还没过：

1. verify artifact gate 还没过
2. automation host gate 也还没过

所以当前最危险的捷径就是：

`在验证入口尚不存在时，先谈自动执行与合并阻断。`

## 5. 五阶段若没有阶段门，会怎样失真

`116` 把路线图分成了五阶段。  
这一章要做的是把它们进一步收紧成真正的门。

## 5.1 Phase 0 若没有 gate，就会把仓库边界误写成产品边界

Phase 0 负责固化研究边界。  
如果没有明确 entry / exit，就很容易出现：

1. 一边承认 extracted，一边又默认自己可完全代表 upstream
2. 一边承认 feature-incomplete，一边又用完整产品口吻制定硬规则

所以 Phase 0 的任务不是写 disclaimer，  
而是正式锁定：

`我们当前究竟有资格对什么对象立法。`

## 5.2 Phase 1 若没有 gate，就会把知识资产错当工程制度

Phase 1 负责固化制度知识。  
如果没有 exit criteria，最常见的幻觉是：

`只要章节写多了，就等于制度存在了。`

但实际上，  
只有当 protocol、ledger、dispatch、constitution、invariants、verification blueprint 这些对象已经能互相引用、互相闭合时，  
才算真正过了 Phase 1。

## 5.3 Phase 2 若没有 gate，就会把“测试想法”错当“验证制度”

Phase 2 负责接入最小验证制度。  
如果 entry gate 不清晰，就会直接跳过几个关键问题：

1. 测试跑在原树还是 prepare 后的树
2. 测试目录如何进入路径与类型制度
3. 单一入口命令是什么
4. 失败时如何解释是仓库缺口还是规则失效

所以 Phase 2 的真正入口不是“大家同意该补测试了”，  
而是：

`验证入口的前置条件已经被定义清楚。`

## 5.4 Phase 3 若没有 gate，就会把伪统一误当统一抽象

Phase 3 负责把局部制度收口成统一接口。  
但统一抽象本质上是在宣布：

`某些差异已经可以被安全忽略。`

如果这件事做早了，  
被抽掉的可能不是重复，  
而是：

`边界条件`

`失败语义`

`灰度路径`

`兼容层`

所以 Phase 3 之前必须先证明：

`这些差异确实是噪音，而不是边界。`

## 5.5 Phase 4 若没有 gate，就会把假自动化误当制度化完成

Phase 4 负责自动执行与长期维持。  
但 CI / pre-merge contract 的外部性最高。

一旦 gate 不严，  
最糟糕的结果不是“不工作”，  
而是：

`稳定地产生错误阻断`

`稳定地制造陈旧正确感`

`稳定地把研究假说伪装成组织约束`

所以 Phase 4 的门必须比前面都更严。

## 6. 建议的阶段门矩阵

## 6.1 Phase 0：固化研究边界

Entry gate：

1. 已明确引用 `README.md:5-6` 的 extracted 定位
2. 已明确引用 `QUICKSTART.md:3-5,60-70,89-103` 的 feature-incomplete / internal-build 边界

Exit criteria：

1. 仓库被统一命名为 research-extracted / feature-incomplete / guard-rich but test-thin
2. 后续章节不再把它写成完整 upstream 的替身

Forbidden shortcut：

1. 直接设计完整 CI 体系
2. 直接以“产品仓库”口吻要求全量重构
3. 直接把缺失模块视作可随时补齐的普通待实现项

## 6.2 Phase 1：固化制度知识

Entry gate：

1. 仓库边界已锁定
2. 高风险对象已拥有稳定的术语和主线章节位置

Exit criteria：

1. protocol / ledger / dispatch / constitution / invariants / layered verification / migration route 形成闭链
2. 首批最小验证对象已能从章节体系中直接抽出

Forbidden shortcut：

1. 还没定义 invariant 就直接补测试
2. 还没定义 dispatch/ledger 就直接做统一状态机

## 6.3 Phase 2：接入最小验证制度

Entry gate：

1. 已明确 `prepare-src` 与验证入口的关系  
   `package.json:7-10`; `scripts/prepare-src.mjs:79-115`
2. 已承认当前没有 tests/CI 宿主  
   本地检查：`.github dirs: 0`, `test/spec files: 0`
3. 已定义首批 suite 与单一执行入口

Exit criteria：

1. 有统一 `verify/test` 命令
2. 有最小 `tests/security/*` 骨架
3. 有测试 tsconfig 或 runner 配置，明确承接 `tests/`
4. 至少首批高优先级 suite 可以被单命令执行

Forbidden shortcut：

1. 还没有单一入口就直接谈自动执行
2. 还没有 failure semantics 就直接把测试结果写成硬阻断
3. 还没有 first suite 落地就先扩写第二轮大抽象

## 6.4 Phase 3：收口统一工程接口

Entry gate：

1. 最小验证制度已经存在
2. 失败结果已经可以被解释为规则失效、仓库缺口或环境差异中的某一类
3. 至少部分局部规则已被 tests 回归保护

Exit criteria：

1. 至少一到两个高风险子系统完成 local guard -> centralized transition 的升级
2. ledger / transition / invariant catalog 开始共享定义
3. 抽象不再只靠章节叙事，而有工程触点承接

Forbidden shortcut：

1. 在 extracted repo 上做一次性全局状态机重构
2. 尚未证明差异是噪音，就提前统一命名和统一流转

## 6.5 Phase 4：自动执行与长期维持

Entry gate：

1. 本地验证入口已稳定
2. 失败解释语义已稳定
3. suite ownership、triage 责任与单一事实入口已明确

Exit criteria：

1. 自动执行宿主已接入
2. pre-merge contract 已存在
3. 失败 triage 与回归维护流程已制度化

Forbidden shortcut：

1. 在 extracted repo 的不稳定假设上直接加 merge gate
2. 用无法解释的 flaky 结果阻断后续工作
3. 把研究特定启发式包装成长期组织宪法

## 7. 从技术角度看，entry gate、exit criteria 与 forbidden shortcut 各守什么

entry gate 守的是：

1. 准入资格
2. 前置依赖是否真的满足
3. 当前阶段的问题是否已被正确命名

exit criteria 守的是：

1. 这一阶段是否真的完成
2. 输出物能否支撑下一阶段
3. “做了一些工作”与“过了这个阶段”之间的差异

forbidden shortcut 守的是：

1. 最诱人的错误越级动作
2. 最高外部性的误压缩
3. 最可能被误认为“效率更高”的失真推进

所以三者缺一不可。  
没有 entry gate，阶段会空转；  
没有 exit criteria，阶段会虚完成；  
没有 forbidden shortcut，阶段会被越级穿透。

## 8. 苏格拉底式反思：如果阶段门写错了，会错在哪里

可以继续追问十个问题：

1. 我们现在掌握的是系统真相，还是系统切片  
   若只是切片，就还没有资格写成全局约束。
2. 我们今天强行抽象，抽掉的是重复，还是不确定性  
   若抽掉的是不确定性，那不是统一，而是伪统一。
3. 自动化准备检查的是格式，还是安全不变量  
   若不变量还未正式化，CI 检查的就只是表面形状。
4. 一条规则失败时，我们能否解释它错在源码、环境、提取过程，还是研究理解  
   若不能，自动化宿主就还没有资格存在。
5. 我们有没有资格宣布哪些局部差异“不重要”  
   若没有，统一抽象就还太早。
6. 如果自动化把一个真实边界场景判错，代价由谁承担  
   外部性越高，阶段门越不能模糊。
7. 我们现在是在描述系统，还是在替系统立法  
   研究更适合描述，制度才适合立法。
8. 有没有经过“先能解释、再能观测、再能对照、最后才自动执行”的影子期  
   若没有，就属于越级推进。
9. 当前抽象是否已经拥有反例处理权  
   没有反例处理权的抽象，本质上只是主路径叙事。
10. upstream 明天若改一处兼容逻辑，我们的自动化会及时失效，还是继续自信地错  
   若更可能后者，就说明 gate 还不够严。

这些追问最终都压回同一句：

`从“我能解释局部现象”到“我有资格把解释写成全局约束”，中间必须有阶段门。`

## 9. 一条硬结论

对这份 Claude Code 研究版源码来说，  
真正成熟的下一步不是：

`把迁移阶段继续写成更漂亮的 roadmap 名词，`

而是：

`把每个阶段正式写成 entry gate、exit criteria 与 forbidden shortcut。`

因为只有这样，  
这份安全研究才不会停在：

`知道该分几步做`

而会进一步升级到：

`知道什么情况下才配进入下一步，什么情况下必须停在原地。`

