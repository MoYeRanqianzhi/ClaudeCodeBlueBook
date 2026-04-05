# 企业托管设置实战：`channelsEnabled`、`allowedChannelPlugins` 与危险配置审批

这篇讲的是管理员如何用托管设置治理 Claude Code，而不是单个用户怎样调命令。

## 1. 先分清托管设置在管什么

从源码看，managed settings 至少在管三类东西：

1. 能力开关
   - 例如 `channelsEnabled`
2. 信任范围
   - 例如 `allowedChannelPlugins`
3. 危险配置变更
   - 例如某些会触发安全对话框的远程设置变化

所以托管设置不是“企业版配置文件”，而是组织级 runtime policy 面。

## 2. `channelsEnabled` 应该怎么用

对 team / enterprise 来说，channels 默认应视为关闭。

推荐策略：

1. 先明确组织是否真的需要外部消息注入。
2. 再显式设置 `channelsEnabled: true`。
3. 不要把“没配这个字段”误当成“默认开放”。

因为源码里的判断很直接：

- 不是 `true` 就视为不允许。

## 3. `allowedChannelPlugins` 应该怎么用

这个字段最关键的一点不是“再加一个 allowlist”，而是：

- 一旦设置，它会替换默认 Anthropic ledger。

也就是说，管理员接手的是最终信任决策，而不是在默认列表上追加几项。

推荐策略：

1. 只列你愿意让其向会话推送消息的 plugin。
2. 把它当成外部输入 allowlist，而不是普通插件市场白名单。
3. 保持列表小而明确，不要为了省事一上来放很宽。

## 4. 危险配置审批为什么重要

`securityCheck.tsx` 明确说明：

- 新的 remote managed settings 如果含有危险项，且与旧值相比发生变化，会触发阻塞式安全对话。

这说明托管设置不是：

- 静默、无限制地下发管理员意志

而是：

- 在某些高风险变化上，仍保留本地显式确认。

## 5. rollout 推荐流程

推荐企业 rollout 顺序：

1. 先只下发最小托管设置。
2. 只开启必须的能力。
3. 对 channels 单独做灰度。
4. 在小范围内观察：
   - channel gate 拦截是否符合预期
   - 权限中继是否有误判
   - 安全弹窗是否过多或过少
5. 再扩大 allowlist。

不要一开始就同时：

- 广泛开 channels
- 广泛开 plugin source
- 立刻依赖 permission relay

## 6. 管理员最容易犯的三种错

### 6.1 把托管设置当作“替用户省事”

托管设置首先是治理工具，不是 convenience layer。

### 6.2 把 allowlist 当成推荐列表

`allowedChannelPlugins` 不是推荐列表，而是：

- 真正有权进入 runtime 的外部输入列表。

### 6.3 把安全审批当成多余摩擦

危险配置审批的意义不是拖慢 rollout，而是防止：

- 远程策略突然把本地会话带入更危险状态。

## 7. 给组织的最小治理建议

1. channels 只按最小必要原则开放。
2. 对 permission relay 单独评估，不和普通 channels 一起默认开放。
3. 把 allowlist 视为“输入预算”而不是“生态预算”。
4. 对每次高风险托管设置变化保留变更说明与内部审批记录。

## 8. 推荐阅读链

- 想看 channels 实操：`04 -> ../api/28`
- 想看更深治理边界：`../api/27 -> ../api/28 -> ../risk/05`
- 想看预算器视角：`../philosophy/22`

## 9. 一句话总结

企业托管设置最有价值的地方，不是替用户配置更多功能，而是把能力开关、输入信任边界和高风险变更确认收束成组织级政策面。
