# 技能发现与 remote skill 边界专题拆分记忆

## 本轮继续深入的核心判断

上一批已经把：

- 技能来源与暴露面
- Claude 如何看见可用能力
- 来源信任与插件锁定

拆开了。

但仍缺一层专门回答：

- `skill_listing`、`skill_discovery`、DiscoverSkills guidance 到底谁是正文主角
- turn-0、后续回合、fresh subagent、fork subagent 为什么会看到不同技能线索
- remote skills、`shortId`、`/skill-feedback` 为什么不能写成普通用户稳定主线

如果这层不拆，正文最容易继续犯两类错：

- 把 relevant skills 写成“Claude 看见的技能总表”
- 把 internal / ant-only feedback loop 写成对外稳定能力

## 苏格拉底式自审

### 问：为什么不把这批直接追加进 `13-system-init、技能提醒与 SkillTool`？

答：因为 13 号页回答的是“Claude 通过哪些链看见能力”，仍偏全景曝光图；这一批更窄，也更锋利，核心是：

- static listing vs relevant reminder
- local skills vs remote skills
- 对外稳定面 vs 条件公开 / 内部反馈面

继续往 13 号页堆，会把“曝光链全景”和“实验搜索边界”揉成一页。

### 问：为什么不把 remote skills 直接写进“技能来源、暴露面与触发”？

答：因为 12 号页回答的是“技能从哪里来、哪些会进入菜单与 SkillTool 集合”，重点仍是本地 / bundled / plugin / MCP 技能来源。remote skills 的核心不是“来源补充”，而是：

- 先 discover
- 再按需加载
- 且属于条件公开 / ant-only 区域

这更像能力公开边界，不像普通来源扩容。

### 问：正文里最该避免的假并列是什么？

答：

- system prompt guidance vs attachment-based reminder
- `skill_listing` broad inventory vs `skill_discovery` relevant subset
- fresh subagent vs fork subagent
- remote skills vs local static skills
- `shortId` / `/skill-feedback` vs `/feedback` / `/issue`

### 问：哪些内容必须继续沉到 memory，而不能进正文？

答：

- `_canonical_<slug>` 这种内部 wire naming
- turn-0 阻塞 discovery、inter-turn prefetch、write-pivot 等调度细节
- `shortId` 只在 ant UI 行里出现、不会进模型 reminder 正文
- `skillSearch` / `DiscoverSkillsTool` producer 文件在当前快照里缺失，因此 remote state 生命周期只有消费端证据
- REPL 与 `QueryEngine` 对 discovered state 的生命周期差异

这些都是维护判断，不是读者行动知识。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/15-技能发现、静态 listing 与 remote skills：为什么“relevant skills”不是技能总表.md`
- `bluebook/userbook/03-参考索引/03-技能与扩展/04-技能发现、静态 listing 与 remote skills 索引.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/03-技能与扩展/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `skill_listing` 与 `skill_discovery` 主要是 attachment 变成的 `system-reminder`
- 主线程 turn-0、后续回合、fresh subagent、fork subagent 会走不同提示链
- remote skills 必须先 discover，再按需加载
- `shortId` / `/skill-feedback` 不应被写成普通用户稳定主线

### 不应写进正文的

- `_canonical_<slug>` 的内部命名约定
- `FILTERED_LISTING_MAX = 30` 这类阈值
- `remoteSkillState` / `remoteSkillLoader` 的内部持久化细节
- ant-only 的完整 telemetry / feedback 线

这些继续只放 `docs/userbook-memory/`。

## 本轮从正文下沉回 memory 的实现细节

### remote skill 的消费端证据与缺口

- 当前快照里可直接读到的是：
  - prompt guidance
  - attachment 装配
  - SkillTool 对 discovered remote skill 的校验与按需加载
- 当前快照里没完整展开的是：
  - `DiscoverSkillsTool`
  - `src/services/skillSearch/*`
  - `remoteSkillState` / `remoteSkillLoader` producer 侧

因此正文只能稳写：

- remote skills 是条件公开 / 实验搜索链的一部分
- 必须先 discover，再由 SkillTool 按需加载

不能稳写：

- 完整 discover state 是怎样生成、缓存、持久化的

### `shortId` 与 `/skill-feedback` 的正确落位

- `shortId` 只出现在 `AttachmentMessage.tsx` 的 `skill_discovery` UI 行渲染中。
- `messages.ts` 发给模型的 `skill_discovery` reminder 只包含 `name + description`。
- `/skill-feedback` 的提示同样只在 ant 条件下作为 UI hint 出现。

正文因此只应写：

- 它们属于内部或条件反馈面

而不应写：

- 这是普通用户默认可用的技能反馈合同

## 多 Agent 汇总后的边界结论

### 稳定对外

- `/feedback`
- `/issue`
- `skill_listing` / `skill_discovery` 作为 attachment-based reminder 这一层对象区分
- remote skills 需要先 discover 再按需加载这一层抽象

### 灰度 / 条件公开

- `EXPERIMENTAL_SKILL_SEARCH`
- DiscoverSkills guidance
- 搜索开启时 bundled + MCP / bundled-only 的 listing 压缩策略
- fresh subagent 的 DiscoverSkills framing

### 内部 / ant-only

- remote canonical skills 的实际执行链
- `shortId`
- `/skill-feedback`
- 相关 telemetry 字段与内部反馈回路

## 后续继续深入时的检查问题

1. 我现在写的是 broad inventory，还是 relevant reminder？
2. 这是主线程、fresh subagent，还是 fork subagent？
3. 这条 remote 能力是稳定公开面，还是实验 / 内部面？
4. 我是不是把 UI 上的人类提示字段写成了模型合同？
5. 当前快照究竟给了完整 producer 证据，还是只有消费端证据？

只要这五问没先答清，正文就会继续把 skill discovery 写成“Claude 总会看到的一张技能总表”。
