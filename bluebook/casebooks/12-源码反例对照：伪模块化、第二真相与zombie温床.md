# 源码反例对照：伪模块化、第二真相与zombie温床

这一章不再收集“演化失败已经发生”的样本，而是收集那些最像“高级工程”，却最容易埋下结构债的坏解法。

它主要回答五个问题：

1. 为什么很多看起来更整齐、更完整、更可复用的结构，反而更不适合长期演化。
2. 为什么源码先进性的坏解法常常不是明显烂，而是看起来很像最佳实践。
3. 哪些反例最能说明 Claude Code 的先进性来自权威面、恢复资产与批评路径，而不是静态美观。
4. 怎样把这些坏解法改写成 Claude Code 式正解。
5. 怎样用苏格拉底式追问避免把这一章读成“作者偏好某种代码风格”。

## 0. 第一性原理

源码先进性最容易被伪装的地方，不是：

- 没有结构

而是：

- 有很多看起来像结构的东西，却没有真正编码出真相、恢复与未来修改路径

所以这一章的目的不是说：

- Claude Code 比别的仓库好看

而是说：

- 哪些“看起来高级”的做法，其实在不断制造第二真相和未来误改点

## 1. 伪模块化 vs 叶子模块与扼流点

### 坏解法

- 把大文件拆成一堆 `utils/helpers/manager`，但每个小文件仍相互引用、共享隐式上下文、一起变化。

### 为什么坏

- 文件数变多了，依赖图没有变浅。
- 复杂性只是被打散，维护者更难找到真正的权威入口。
- 最终形成“看起来很模块化，实际上更难改”的伪优化。

### Claude Code 式正解

- 把真正高复用、低依赖的判断压成 leaf module。
- 把高风险编排留在少数 choke point。

### 改写路径

1. 先找哪些逻辑必须多处共用但不该拖重依赖。
2. 把它们抽成 leaf。
3. 其余编排逻辑继续留在原控制面，不做形式主义拆分。

## 2. 第二真相 vs Authoritative Surface

### 坏解法

- UI 一份状态、宿主一份状态、metadata 一份状态、恢复再猜一份状态，大家“差不多一致”。

### 为什么坏

- 局部都像对的，但跨平面时没有一份值得信的当前态。
- 故障表现常是 stale mode、stale pending_action、resume 后主语漂移。

### Claude Code 式正解

- 把 mode、session state、external metadata、SDK status 各自收口进 authoritative surface。
- 再用镜像或投影分发。

### 改写路径

1. 先找哪份状态最接近权威当前态。
2. 让其他面从它派生。
3. 禁止多个调用点各自“顺手同步”。

## 3. Transport 差异泄漏 vs Shell Confinement

### 坏解法

- `v1/v2`、`local/remote`、`structured/streaming` 差异直接在业务层扩散，调用方到处 `if transport === ...`。

### 为什么坏

- 协议代际变化会穿透 query、UI、恢复、宿主。
- 一次 transport 迁移变成全仓迁移。

### Claude Code 式正解

- 把差异收进 transport shell / compat shell，让高层只看到稳定语义面。

### 改写路径

1. 先定义统一 transport surface。
2. 把认证、注册、delivery、state writeback 等差异压进 construction site。
3. 业务层只认壳层语义。

## 4. Registry 变业务中心 vs 薄 Registry

### 坏解法

- 最初只是注册器，后来顺手塞 feature flag、fallback、权限逻辑、实例缓存，最终变成隐藏协调中心。

### 为什么坏

- registry 从“装配秩序”膨胀成“第二业务层”。
- 任何新增 provider 都得理解一团历史逻辑。

### Claude Code 式正解

- registry 保持薄，只做 slot / create / self-register。
- 业务判断留在外层控制面。

### 改写路径

1. 先把 registry 里的条件分支按“装配”与“业务”分离。
2. 保留自注册，但把业务决策拉回显式控制面。
3. 为 registry 单独维护安全导入和切环规则。

## 5. 恢复资产缺席 vs Recovery Asset Ledger

### 坏解法

- 把恢复理解成“重放聊天记录”或“重新拉一次状态”，没有 pointer、snapshot、replacement log、plan snapshot 等恢复资产。

### 为什么坏

- 进程一死、路径一变、transport 一换，就只能靠猜。
- 看似能恢复历史，其实恢复不到正确当前态。

### Claude Code 式正解

- 把 bridge pointer、file snapshot、content replacements、context-collapse metadata、worktree state 都做成正式 recovery asset。

### 改写路径

1. 先列出“崩溃后还必须成立的真相”。
2. 为每项指定持久句柄。
3. 不要先写 resume 按钮，再补资产。

## 6. Zombie 温床 vs Fresh-State Merge

### 坏解法

- async 结果回来后直接把旧对象整体写回；finally 无条件 cleanup；await 前抓的 snapshot 事后继续当真。

### 为什么坏

- 旧 query、旧 task、旧 cursor 会在新状态上“复活”。
- 把已经完成或切换的对象写回成半死不活状态。

### Claude Code 式正解

- generation 防 stale finally。
- fresh-state merge 防 pre-await snapshot clobber。
- replacement fate freeze 防跨轮反悔。

### 改写路径

1. 把“全量对象回写”改成 patch merge。
2. 为长链 async 引入 generation / freshness gate。
3. 明确哪些命运一旦决定就冻结。

## 7. 未来维护者被排除 vs 批评路径进结构

### 坏解法

- 关键约束只在作者脑中、PR 讨论里或事故复盘文档里，源码本身只剩“看起来整洁”的结构。

### 为什么坏

- 新维护者无法判断哪里能改、为什么不能改、删 shim 前要验证什么。
- 最终只能模仿而不能治理。

### Claude Code 式正解

- 风险命名、制度注释、迁移垫片、退出条件、checklist、导航层一起存在，让未来维护者成为正式消费者。

### 改写路径

1. 先把最容易误改的边界写成命名和注释。
2. 再补台账、演练模板与反查入口。
3. 不要等结构稳定后才补“文档”。

## 8. 苏格拉底式追问

在你读完这些对照样例后，先问自己：

1. 我现在做的是模块化，还是伪模块化。
2. 这个系统到底有几份当前真相。
3. transport 差异是否还被困在 shell 里。
4. 恢复资产是正式对象，还是事后补救物。
5. 我是在清除 zombie 风险，还是在制造更隐蔽的 zombie 温床。
