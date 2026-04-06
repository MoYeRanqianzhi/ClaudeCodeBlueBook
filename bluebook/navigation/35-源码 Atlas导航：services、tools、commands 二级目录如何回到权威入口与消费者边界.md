# 源码 Atlas导航：services、tools、commands 二级目录如何回到权威入口与消费者边界

这一篇不再回答“顶层目录大致分成什么平面”，而是回答一个更接近源码实战阅读的问题：

- 当读者已经知道 `commands/`、`tools/`、`services/` 各自承担什么角色之后，下一步就不该继续停在一级地图，而要知道这些目录往下拆到二级时，哪些是权威入口，哪些只是消费者子集，哪些是危险改动面。

它主要回答五个问题：

1. 为什么 `api/30` 之后仍需要单独讨论源码 atlas 层。
2. 为什么真正成熟的源码地图，不是把目录列得更全，而是更快暴露权威入口、消费者边界与误改风险。
3. 怎样把 `services/`、`tools/`、`commands/` 三大平面分别压成二级目录 atlas。
4. 为什么这一层更适合继续落在 `api/`，而不是重新改写成架构篇。
5. 怎样用苏格拉底式追问避免把 atlas 写成“更长的目录树”。

这里还应先多记一句：

- `35` 不新建 ladder，只把 `contract -> registry -> current-truth surface -> consumer subset -> hotspot kernel -> mirror gap discipline` 投影到二级目录阅读动作里；它是 atlas projection page，不是第二条源码质量前门。
- 如果争议已经变成“这页到底有没有首答权”，不要继续在 atlas 页内部打转，直接回 `navigation/04` 处理 speaking-rights 问题。

如果问题还没分清自己到底在问哪一种 atlas 事实，先用这张四路由短表：

1. 问 canonical ladder、rung 定义与降格规则
   - 先回 `01 + guides/102`
2. 问 repo-specific atlas 正文、authority file、consumer subset 与 reject path
   - 先回 `api/46-50`
3. 问 atlas 模板、gap note 与 mirror-gap 记法
   - 先回 `guides/102`
4. 问 speaking-rights、route dispute 或 atlas 是否越权成第二前门
   - 先回 `navigation/04`

## 1. Services 二级目录 Atlas

这一条线最该先交四件事：

1. authority file：
   - 先回 `30` 确认顶层平面，再进 `../api/46` 找具体 authority file。
2. consumer subset：
   - 哪些 service 只给 continuation、host、UI 或 observability 投影，而不直接宣布真相。
3. danger surface：
   - 哪个 stale write、recovery object、config merge 或 drift ledger 最容易在时间上撒谎。
4. reject path：
   - 一旦某个 service 看起来像权威真相，却只是在投影，先回 `../api/46` 的 authority file，再回 `../philosophy/76` 的 reject 原则。

## 2. Tools 二级目录 Atlas

这一条线最该先交四件事：

1. authority file：
   - 先回 `30` 认清 `Tool.ts / tools.ts` 的分工，再进 `../api/47`。
2. consumer subset：
   - 哪些工具只在 simple mode、REPL、deferred visibility、MCP 或特定 host 下可见。
3. danger surface：
   - visible-set、deny rule、mode 裁切、cache-stable 排序与 execution orchestration 哪些最容易失真。
4. reject path：
   - 一旦工具行为不可信，先回 `tools.ts`、`Tool.ts` 与 `../api/47` 的 authority 段，而不是先看某个工具目录名字。

## 3. Commands 二级目录 Atlas

这一条线最该先交四件事：

1. authority file：
   - 先回 `30` 认清 `COMMANDS()` 与 runtime assembly，再进 `../api/48`。
2. consumer subset：
   - 哪些命令是 public、dynamic、feature-gated、internal-only 或 external-build eliminated 子集。
3. danger surface：
   - assembly 顺序、入口壳层、构建剔除与 user-type gate 哪些最容易把公开边界写坏。
4. reject path：
   - 一旦命令看起来像公开能力，却更像内部命令面，先回 `commands.ts` 与 `../api/48` 的 authority 段，再回 `../philosophy/76`。

## 4. 为什么这层继续落在 API

因为这层要回答的核心问题不是：

- 运行时内部怎样工作

而是：

1. 读者应该从哪个目录进入。
2. 哪个二级目录更接近 public control surface。
3. 哪些目录只对特定消费者开放。
4. 哪些入口一改就会影响 cache、权限、恢复或 host 协议。

这些都更接近：

- 源码能力 atlas

而不是更高一层的机制抽象。

## 5. 一句话用法

`30` 回答“顶层哪些平面存在”，`35` 回答“进入这些平面后，先找哪个 authority file、哪些只是 subset、哪里最危险、第一条 reject path 应回哪”。

## 6. 苏格拉底式自检

在你准备宣布“这份 atlas 已经够用了”前，先问自己：

1. 这份地图是在帮助读者更快找到权威入口，还是只在把树打印得更长。
2. 我是否区分了 public control surface 和 internal-only / feature-gated surface。
3. 我是否区分了真正收口点和只是消费它的组件。
4. 这份 atlas 能否帮助后来者更早看见危险改动面和 reject path，而不只是更快看见文件名。
