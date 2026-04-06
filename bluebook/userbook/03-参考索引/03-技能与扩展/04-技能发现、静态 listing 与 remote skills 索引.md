# 附：技能发现、静态 listing 与 remote skills 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/15-技能发现、静态 listing 与 remote skills：为什么“relevant skills”不是技能总表.md`
- `05-控制面深挖/13-system-init、技能提醒与 SkillTool：Claude 如何看见可用能力.md`

它不是这组索引的主判断前门，而是补充 `03` 的附页：

- `03` 先回答“给谁看哪层、谁最后拍板”。
- 这页再补“线程/回合路径、remote skills 与反馈面有哪些额外边界”。

先记这一页的最短三分法：

- `skill_listing` 是库存。
- `relevant skills` 是相关性子集。
- `remote skills` 是 discover 之后才进入准入/加载链的能力。

只要这三层没先分开，`relevant skills` 就会被误写成技能总表。

## 1. 四类最容易混淆的技能线索

| 对象 | 面向谁 | 作用 | 最容易误判 |
| --- | --- | --- | --- |
| DiscoverSkills guidance | 模型 | 告诉 Claude 何时继续 discover | 误写成技能表本体 |
| `skill_listing` | 模型 | broad inventory：当前可用 SkillTool 技能库存 | 误写成用户 UI 列表 |
| `skill_discovery` | 模型 | 当前任务相关技能子集 | 误写成全量技能表 |
| `shortId` / `/skill-feedback` | 用户 UI | 内部或条件反馈回路 | 误写成模型上下文字段 |

## 2. 四条不同的线程 / 回合路径

| 路径 | 主要链路 | 结果 |
| --- | --- | --- |
| 主线程 turn-0 | `processUserInput -> getAttachmentMessages -> getTurnZeroSkillDiscovery` | 首轮阻塞 relevant skills discovery |
| 主线程后续回合 | `query -> startSkillDiscoveryPrefetch -> collectSkillDiscoveryPrefetch` | 工具执行后注入 relevant skills |
| fresh subagent | `AgentTool -> enhanceSystemPromptWithEnvDetails -> runAgent -> query` | 有 DiscoverSkills framing，但不复用主线程 turn-0 发现链 |
| fork subagent | 复用父线程 rendered system prompt 与 forked messages | 更接近继承父线程已形成的提示环境 |

## 3. `skill_listing` 与 `skill_discovery` 的真实角色

| 对象 | 模型真正收到什么 | 用户 transcript 常看到什么 |
| --- | --- | --- |
| `skill_listing` | `The following skills are available for use with the Skill tool:` 的 `system-reminder` | `N skills available` 一类短提示 |
| `skill_discovery` | `Skills relevant to your task:` 的 `system-reminder` | `N relevant skills: ...` 一类短提示 |

## 4. remote skills 的硬边界

| 边界 | 含义 |
| --- | --- |
| 不在 local command registry | 不是普通本地 skill 的另一种显示 |
| 先 discover 再调用 | 若 session state 中没有 discovered meta，SkillTool 直接拒绝 |
| 按需加载 | 通过 `loadRemoteSkill(...)` 拉取，而不是预先进入 static listing |
| 条件公开 / 实验面 | 受 `EXPERIMENTAL_SKILL_SEARCH` 与 `USER_TYPE === 'ant'` 等条件影响 |

## 5. 搜索开启时的 listing 裁剪

| 场景 | 当前实现行为 |
| --- | --- |
| 普通 listing 组装 | `getSkillToolCommands()` + `getMcpSkillCommands()` |
| 搜索开启 | 优先裁到 bundled + MCP |
| 仍过大 | 进一步退到 bundled-only |

这部分应写成：

- 当前实现可见的上下文预算策略

而不是：

- 对用户长期稳定承诺的产品规则

## 6. 反馈面的公开性边界

| 面 | 更稳的分类 |
| --- | --- |
| `/feedback` | 外部用户可稳定依赖的反馈面 |
| `/issue` | 外部用户可稳定依赖的问题上报面 |
| `shortId` | UI / 内部辅助字段 |
| `/skill-feedback` | 内部或条件反馈回路，不应写成普通用户主线 |

## 7. 六个高价值判断问题

- 这条技能线索是 guidance、inventory，还是 relevant reminder？
- 当前在讨论主线程首轮、后续回合，还是 subagent？
- 这是本地静态技能，还是 discover 后的 remote skill？
- 这里是模型真实收到的内容，还是用户 UI 的压缩展示？
- 这条行为是稳定主线，还是实验搜索链才成立？
- 我是不是把 `shortId` / `/skill-feedback` 误写成了普通用户公开合同？

## 源码锚点

- `claude-code-source-code/src/constants/prompts.ts`
- `claude-code-source-code/src/utils/processUserInput/processUserInput.ts`
- `claude-code-source-code/src/query.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/tools/SkillTool/SkillTool.ts`
- `claude-code-source-code/src/tools/AgentTool/AgentTool.tsx`
- `claude-code-source-code/src/commands/feedback/index.ts`
- `claude-code-source-code/src/components/Feedback.tsx`
