# `createBridgeSession.environment_id`、`source`、`session_context` 与 `permission_mode` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/176-createBridgeSession.environment_id、source、session_context 与 permission_mode：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属.md`
- `05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md`
- `05-控制面深挖/39-name、permission-mode、sandbox 与 session title：为什么 standalone remote-control 的 host flags、session 默认策略与标题回填不是同一种继承.md`

边界先说清：

- 这页不是 host-flag inheritance 页。
- 这页不是 environment register authority 页。
- 这页只抓 session-create request body 内部的字段主语分裂。

## 1. 四种字段主语

| 字段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| `environment_id` | session attach target | 会话挂到哪条 live env |
| `source` | session origin declaration | `source: 'remote-control'` |
| `session_context` | context payload | git/model/source/outcome 上下文 |
| `permission_mode` | default policy | 会话默认权限策略 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `environment_id` 就是在说 session 的来源 | 它先是在说 attach target |
| `source: 'remote-control'` 能区分 standalone 与 `/remote-control` host | 它声明的是更粗的来源家族 |
| `session_context` 只是在详细解释 `source` | 它是上下文载荷，不是来源声明 |
| `permission_mode` 和其他字段一样都在定义 session 身份 | 它定义的是默认策略，不是 attach/source/context |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | attach/source/context/policy 四层主语不同；`source:'remote-control'` 同时覆盖 standalone 与 REPL wrapper |
| 条件公开 | `permission_mode` 仅在有值时写入；git source/outcome 依 repo 上下文而定 |
| 内部/灰度层 | org UUID、beta header、typed SessionResource 当前未正面暴露 source、git context 构造细节 |

## 4. 五个检查问题

- 当前字段在回答 attach、source、context，还是 policy？
- 当前字段改动后，变化的是附着对象、来源家族、上下文载荷，还是默认策略？
- 我是不是把 `environment_id` 错写成 session provenance？
- 我是不是把 `source:'remote-control'` 错写成 host identity？
- 我是不是又把这页写回 39 的 flag 继承或 174 的 env authority？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/initReplBridge.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
