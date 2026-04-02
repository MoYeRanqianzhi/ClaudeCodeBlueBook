# 安全状态编辑主权速查表：status family、allowed editor、allowed operator与forbidden outsider

## 1. 这一页服务于什么

这一页服务于 [78-安全状态编辑主权：为什么状态替换语法之后，还必须继续回答谁有资格编辑谁的状态](../78-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E7%BC%96%E8%BE%91%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%8A%B6%E6%80%81%E6%9B%BF%E6%8D%A2%E8%AF%AD%E6%B3%95%E4%B9%8B%E5%90%8E%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E7%BB%A7%E7%BB%AD%E5%9B%9E%E7%AD%94%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E7%BC%96%E8%BE%91%E8%B0%81%E7%9A%84%E7%8A%B6%E6%80%81.md)。

如果 `78` 的长文解释的是：

`为什么 replacement grammar 之后还必须继续追问编辑主语，`

那么这一页只做一件事：

`把不同 status family 的 allowed editor、allowed operator 与 forbidden outsider 压成一张主权矩阵。`

## 2. 状态编辑主权矩阵

| status family | allowed editor | allowed operator | 依据是什么 | forbidden outsider | 若被 outsider 编辑会出什么问题 | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| teammate lifecycle | teammate lifecycle hook | `fold`、`add` | 同一 hook 同时理解 spawn / shutdown 重复事件的聚合语义 | 不理解 teammate 事件语义的任意其他 hook | 聚合规则失真，重复事件被误压缩或误覆盖 | `useTeammateShutdownNotification.ts:18-46,49-77` |
| fast mode cooldown family | fast mode notification hook | `invalidates`、`add` | 同一家族内成对互斥 key，由同一 subsystem 定义 | 与 fast mode 无关的其他状态发布者 | 冷却开始 / 结束关系被误作废，模式判断失真 | `useFastModeNotification.tsx:8-11,101-121` |
| settings error | settings error hook | `add`、`remove` | 同一 hook 既检测错误也知道何时归零 | 任意旁路 hook 用裸 key 删除 | 仍存在的错误被静默抹除，诊断面失真 | `useSettingsErrors.tsx:37-48` |
| external editor hint | Notifications 组件内该逻辑块 | `add`、`remove` | 同一逻辑掌握 hint 的成立与失效条件 | 不理解 hint 条件的任意其他调用者 | hint 过早消失或残留，生命周期失真 | `Notifications.tsx:147-162` |
| ultrathink / ultraplan / stash-hint | PromptInput 自身 | `add`、`remove` | 触发器和取消条件都在 PromptInput 内 | 无关输入子系统 | 当前输入态被错误改口，用户动作提示偏移 | `PromptInput.tsx:747-769,787-790` |
| IDE status family | IDE status hook 作为 family editor | sibling `add`、sibling `remove` | 同一 subsystem 同时理解 disconnected、install error、JetBrains-specific 状态关系 | 其他不理解 IDE family 排序的外部层 | 原因态、症状态与家族优先级被打乱 | `useIDEStatusIndicator.tsx:78-152` |
| notification 全局 current 槽 | notifications context + layout 组合 | `priority` 调度、`coexist` 边界 | context 决定 current/queue，layout 决定哪些维度并列展示 | 任意单个 key owner 试图独占整个 footer | 正交状态被错误压平，整体状态面退化 | `notifications.tsx:45-76,78-117,172-213`、`Notifications.tsx:286-330` |

## 3. 最短判断公式

看到一个状态编辑动作时，先问四句：

1. 当前编辑者是不是这个状态家族的 owner 或 family editor
2. 它执行的是 owner remove、family fold、family invalidate，还是在越权碰别人的状态
3. 当前关系是生命周期收尾、互斥替换，还是聚合压缩
4. 如果换成别的 outsider 来编辑，最容易破坏的是聚合语义、互斥语义，还是生命周期边界

## 4. 最常见的五类主权错误

| 主权错误 | 会造成什么问题 |
| --- | --- |
| outsider 直接 `remove` 别人的 key | 仍有效的状态被静默抹除 |
| outsider 定义别人的 `fold` 规则 | 重复事件被错误聚合 |
| outsider 对不理解的状态家族做 `invalidate` | 互斥关系被误判 |
| 单个 key owner 擅自决定全局 coexist | 正交状态被错误压平 |
| 只靠 key 名约定，不给主权边界 | 代码规模变大后容易字符串互殴 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
replacement grammar 真正闭环的最后一步不是再加新动词，  
而是：

`把每个编辑动词交给正确的状态家族主语。`
