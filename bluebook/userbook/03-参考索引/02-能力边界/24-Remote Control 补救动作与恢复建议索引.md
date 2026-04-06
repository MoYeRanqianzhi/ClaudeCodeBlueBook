# Remote Control 补救动作与恢复建议索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/35-Workspace Trust、login、restart remote-control、fresh session fallback 与 retry：为什么 bridge 的补救动作不是同一种恢复建议.md`
- `05-控制面深挖/34-No recent session found、Session not found、environment_id 与 try running the same command again：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败.md`
- `05-控制面深挖/23-Workspace Trust、Bridge Eligibility 与 Trusted Device：为什么 remote-control 的 trust、auth、policy 不是同一把钥匙.md`

## 1. 五类补救动作总表

| 对象 | 典型提示 | 系统政策 | 用户动作 | continuity 命运 |
| --- | --- | --- | --- | --- |
| `Workspace Prerequisite` | `run \`claude\` in ... first` | 直接拒绝 bridge 启动 | 先在该目录完成 trust | 还没开始 |
| `Account Prerequisite` | `Please use \`/login\`` | 直接拒绝 bridge API / host 启动 | 修复登录与订阅前提 | 还没开始 |
| `Expired Bridge Host` | `restart with \`claude remote-control\` or /remote-control` | 要求重建 remote-control | 重启 bridge | 旧 host continuity 结束 |
| `Continuity Downgrade` | `Creating a fresh session instead` | 自动从 resume 降级到 fresh start | 接受新的 session 轨迹 | 旧 continuity 断，当前启动继续 |
| `Transient Retry` | `try running the same command again` | 保留 pointer，等待下一次重试 | 再跑一次同样命令 | 旧 continuity 暂时保留 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `run claude first` = `/login` | trust 与 auth 是两层前提 |
| `/login` = restart remote-control | 一个修身份，一个重建 host |
| `fresh session instead` = 已恢复成功 | 这是 continuity downgrade |
| `retry same command` = 安慰句 | 它对应保留旧 pointer 的系统政策 |
| 看到 `/login` 就一定是纯 auth 失败 | 也可能是 invalid resume source 附带的可能原因 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | trust 建立、`/login`、restart remote-control、fresh fallback、retry same command |
| 条件公开 | 普通权限型 `403`、`Session not found` 的 login hint、REPL 的短状态词 |
| 内部/实现层 | token refresh、expiry errorType 判定、suppressible 403、pointer 清理细节 |

## 4. 六个高价值判断问题

- 这次坏掉的是 workspace、account、host、continuity，还是一次瞬态 reconnect？
- 系统现在是在要求你建立前提、重建 host，还是仅仅重试？
- 当前命令是必须退出，还是已经自动降级成 fresh session 继续跑？
- 旧 continuity 是已经作废，还是被故意保留？
- 文案里提到 `/login`，是在说纯 auth failure，还是在提示 invalid resume source 的可能原因？
- 我是不是又把 trust、auth、restart、fallback 与 retry 写成同一种恢复建议？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/types.ts`
