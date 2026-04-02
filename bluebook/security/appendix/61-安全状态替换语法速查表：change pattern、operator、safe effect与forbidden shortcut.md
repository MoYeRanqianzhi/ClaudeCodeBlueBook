# 安全状态替换语法速查表：change pattern、operator、safe effect与forbidden shortcut

## 1. 这一页服务于什么

这一页服务于 [77-安全状态替换语法：为什么新增、折叠、失效、移除与共存必须是不同的状态动作，而不能统一成再发一条通知](../77-%E5%AE%89%E5%85%A8%E7%8A%B6%E6%80%81%E6%9B%BF%E6%8D%A2%E8%AF%AD%E6%B3%95%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%96%B0%E5%A2%9E%E3%80%81%E6%8A%98%E5%8F%A0%E3%80%81%E5%A4%B1%E6%95%88%E3%80%81%E7%A7%BB%E9%99%A4%E4%B8%8E%E5%85%B1%E5%AD%98%E5%BF%85%E9%A1%BB%E6%98%AF%E4%B8%8D%E5%90%8C%E7%9A%84%E7%8A%B6%E6%80%81%E5%8A%A8%E4%BD%9C%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E7%BB%9F%E4%B8%80%E6%88%90%E5%86%8D%E5%8F%91%E4%B8%80%E6%9D%A1%E9%80%9A%E7%9F%A5.md)。

如果 `77` 的长文解释的是：

`为什么状态变化不能统一压成“再发一条通知”，`

那么这一页只做一件事：

`把不同 change pattern、应使用的 operator、safe effect 与 forbidden shortcut 压成一张状态编辑矩阵。`

## 2. 状态替换语法矩阵

| change pattern | operator | safe effect | forbidden shortcut | 如果走错会发生什么 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| 同一语义的重复事件持续到来 | `fold` | 把重复事件升格成聚合事实，而不是刷屏 | 继续 append 多条相同事件 | 噪声淹没有效信息，用户看不到聚合关系 | `notifications.tsx:16-23,121-169`、`useTeammateShutdownNotification.ts:18-46,49-77` |
| 新状态与旧状态互斥 | `invalidates` | 正式废止旧状态，避免旧真相复活 | 只抢位、不驱逐 | 新提示消失后旧提示回潮 | `notifications.tsx:6-14,78-117,172-191`、`useFastModeNotification.tsx:101-121` |
| 状态拥有者发现自身条件不再成立 | `remove` | 由拥有者主动收尾自己的状态 | 等 timeout 或等别的状态来赶走它 | 已失效提示继续占位，生命周期边界失真 | `notifications.tsx:193-213`、`useSettingsErrors.tsx:37-48`、`Notifications.tsx:150-162`、`PromptInput.tsx:748-769,787-790` |
| 高优先级风险需要立刻进入前景 | `priority: immediate`，必要时联动 `invalidates` | 当前最关键风险立即抢占用户注意力 | 把 immediate 误当成完整替换语义 | 只完成前景抢位，没完成旧状态治理 | `notifications.tsx:78-117`、`useReplBridge.tsx:102-111` |
| 正交维度的状态同时成立 | `coexist` | 多维事实并列展示，不彼此压平 | 误用单一 current 或互相替换 | 不同维度事实被错误压成一条线 | `Notifications.tsx:286-330` |
| 原因态覆盖症状态 | `remove` 或 `invalidates`，取决于关系归属 | 更具体原因接管用户动作路由 | 让症状态继续和原因态并存 | 用户停留在模糊症状层，修复方向错误 | `useIDEStatusIndicator.tsx:78-152` |

## 3. 最短判断公式

看到一次状态变化时，先问四句：

1. 这是重复、互斥、收尾，还是正交共存
2. 当前更适合 `fold`、`invalidate`、`remove`，还是根本不该替换
3. 当前 operator 会不会让旧状态复活或错误残留
4. 用户下一步动作会不会因此被导向错误路径

## 4. 最常见的六类语法错误

| 语法错误 | 会造成什么问题 |
| --- | --- |
| 把重复事件当 append | 刷屏，不形成聚合语义 |
| 把互斥状态当 coexist | 互斥真相并存，形成裂脑 |
| 把 owner 收尾交给 timeout | 生命周期结束得不干净 |
| 把 immediate 当成完整替换 | 只抢位，不治理旧状态 |
| 把正交状态压成单线 current | 多维状态事实被错误丢失 |
| 把原因态和症状态混成同一层 | 用户看不出真正根因 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
状态治理真正成熟的标志不是字段更多，  
而是：

`每一次状态变化都选对了自己的编辑动词。`
