# Remote Control build 不可用、资格不可用、组织拒绝与权限噪音索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/36-Remote Control build 不可用、资格不可用、组织拒绝与权限噪音：为什么 bridge 的 not enabled、policy disabled、not available 与 Access denied 不是同一种“不能用”.md`
- `05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md`
- `05-控制面深挖/35-Workspace Trust、login、restart remote-control、fresh session fallback 与 retry：为什么 bridge 的补救动作不是同一种恢复建议.md`

## 1. 六类“不能用”对象总表

| 对象 | 典型提示 | 发生时机 | 用户动作 |
| --- | --- | --- | --- |
| `Build Unavailable` | `not available in this build` | 启动前 | 换支持 bridge 的构建 |
| `Account Entitlement Missing` | `not yet enabled for your account`、`requires a claude.ai subscription` | 启动前 | 重新登录、满足订阅/资格、等待开通 |
| `Policy Disabled` | `disabled by your organization's policy` | 启动前 | 找组织管理员 |
| `Runtime Availability Denied` | `not available for your account`、`may not be available for this organization` | 运行时 | 接受当前账户/组织不可用 |
| `Core Permission Denied` | `Access denied (403) ... Check your organization permissions.` | 运行时 | 检查组织权限 |
| `Cosmetic Permission Noise` | suppressible `403` | 运行时 | 用户面通常不该看到 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| build 不可用 = 账号没资格 | 一个是构建缺失，一个是 entitlement 未开 |
| 账号未开 = 组织策略禁用 | 一个是产品资格，一个是组织显式禁止 |
| policy disabled = runtime not available | 一个是 preflight denial，一个是 runtime availability denial |
| `Access denied (403)` = 所有权限问题都该展示 | 只有核心权限拒绝应进用户面 |
| suppressible `403` = Remote Control 主能力挂了 | 它是附属权限噪音 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | build 不可用、资格未开、policy 禁用、runtime 不可用、核心权限拒绝 |
| 条件公开 | full-scope token、organization eligibility、运行时 404 的上下文收窄 |
| 内部/实现层 | `isSuppressible403`、降噪逻辑、side-operation scope 细节 |

## 4. 六个高价值判断问题

- 这次卡的是 build、账号资格、组织策略，还是运行时环境可用性？
- 当前失败是在 preflight 就能判定，还是 API 调用后才暴露？
- 这条错误是在说“核心功能被拒”，还是“附属操作权限不够”？
- 我现在该重新登录、找管理员、接受当前账户不可用，还是直接忽略噪音？
- 我是不是把 runtime availability denial 写成了 policy denial？
- 我是不是又把 suppressible `403` 写成了主能力不可用？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
