# 安全动作算子速查表：operator、trigger、effect与representative source

## 1. 这一页服务于什么

这一页服务于 [129-安全真相动作算子：为什么Claude Code不是在做静态权限判断，而是在执行allow、deny、degrade、step-up、de-scope、suppress与restore的控制面语法](../129-%E5%AE%89%E5%85%A8%E7%9C%9F%E7%9B%B8%E5%8A%A8%E4%BD%9C%E7%AE%97%E5%AD%90%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E6%98%AF%E5%9C%A8%E5%81%9A%E9%9D%99%E6%80%81%E6%9D%83%E9%99%90%E5%88%A4%E6%96%AD%EF%BC%8C%E8%80%8C%E6%98%AF%E5%9C%A8%E6%89%A7%E8%A1%8Callow%E3%80%81deny%E3%80%81degrade%E3%80%81step-up%E3%80%81de-scope%E3%80%81suppress%E4%B8%8Erestore%E7%9A%84%E6%8E%A7%E5%88%B6%E9%9D%A2%E8%AF%AD%E6%B3%95.md)。

如果 `129` 的长文解释的是：

`为什么 Claude Code 的安全控制面其实是在执行一组稳定的动作算子，`

那么这一页只做一件事：

`把主要 operator 的 trigger、effect 与 representative source 压成一张矩阵。`

## 2. 动作算子矩阵

| operator | trigger | effect | representative source |
| --- | --- | --- | --- |
| `allow` | policy / approval / proof satisfied | 能力继续保留 | `cli.tsx:151-159`; `securityCheck.tsx:48-55` |
| `deny` | 主权/高危边界证明断裂 | 路径关闭 | `auth.ts:1920-1969`; `securityCheck.tsx:67-70` |
| `degrade` | availability failure with acceptable stale fallback | 真相变弱但继续运行 | `remoteManagedSettings/index.ts:432-442,492-501` |
| `step-up` | authority level insufficient | 切换到更高证明流程 | `mcp/auth.ts:1461-1470,1625-1650` |
| `de-scope` | 完整能力面无法被证明安全 | 裁掉高风险子能力 | `permissionSetup.ts:510-579`; `sandboxTypes.ts:18-24,78-83,113-119` |
| `suppress` | 被更高意图/重复对象覆盖 | 对象不进主舞台但保留说明 | `mcp/config.ts:228-309,1216-1228` |
| `restore` | 高风险上下文结束 | 恢复先前暂存能力 | `permissionSetup.ts:561-579` |

## 3. 最短判断公式

判断某段逻辑属于哪种 operator 时，先问四句：

1. 系统是在放、关、降、升、裁、压，还是恢复
2. 触发它的是哪类边界变化
3. 结果是能力消失、变弱、变窄，还是回放
4. 这条动作有没有独立的代表性源码锚点

## 4. 最常见的三类误读

| 误读 | 实际问题 |
| --- | --- |
| 把所有动作都压成 deny | 丢掉了系统的精细安全语法 |
| 把 suppress 当 error | 忽略“被覆盖但非非法”的语义 |
| 把 restore 忽略掉 | 看不见高风险窗口结束后的状态回放 |

## 5. 一条硬结论

Claude Code 的安全控制面不是：

`一组布尔开关，`

而是：

`一套按风险对象持续变换系统真相的动作算子。`

