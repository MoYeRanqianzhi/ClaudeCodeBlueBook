# session-url-readiness wording alignment 拆分记忆

## 本轮继续深入的核心判断

这一轮继续紧接上一刀，

不是继续改整块多前端分层，

而是只收：

- `16-IDE、Desktop、Mobile 与会话接续专题`

里 `/session`

最容易误写成二元开关的那一句。

## 为什么这轮值得单独提交

### 判断一：`remote bit 为真`

不等于：

- 当前前端已经拥有可对外继续交付的 remote session URL

`16`

这一页原本写成：

- 只在 `getIsRemoteMode()` 为真时启用

这句话本身不算错，

但它太容易被读成：

- 只要 remote mode 为真，`/session` 就一定能稳定给出 URL / QR

而并行只读分析已经指出：

- remote bit 为真
  和
- `remoteSessionUrl` 已就绪

不是同一个合同层级。

### 判断二：这刀比继续扩写 `06` 更像“接续对象合同”本身

上一刀 `06`

收的是：

- 稳定主线 / 稳定但带前提 / 灰度或条件面

而这一刀 `16`

收的是：

- `/session` 这个接续对象到底以什么条件交付

两刀正好一前一后：

1. 先收总览页的稳定/条件语气
2. 再收接续专题里更精确的对象合同

## 这轮具体怎么拆

这轮只做两件事：

1. 把：
   - `只在 getIsRemoteMode() 为真时启用`
   收成：
   - `只有在 remote session URL 已就绪时，才真正交付 URL / QR 这一类 viewer 接续对象`
2. 再补三句显式拆分：
   - remote bit 为真，只说明你已在 remote 语境里
   - 它不自动等于 URL 一定可交付
   - attached viewer 之类场景也可能 remote 为真，但当前前端不拥有那条可分享 URL

这样：

- `/session`
  不再被写成 remote mode 的简单镜像
- viewer 接续对象
  和 remote 语境 bit
  被明确拆开

## 苏格拉底式自审

### 问：为什么不能继续把 `/session` 简写成“remote mode 下启用”？

答：因为对用户来说，真正值钱的不是“有没有 remote bit”，而是“现在能不能拿到可继续交付的 URL / QR”。前一句是宿主语境，后一句才是接续对象。

### 问：为什么这刀不一起改 `/desktop`、`/mobile`？

答：因为这一刀只收 `/session` 的 URL-ready 合同，保持最小粒度。`/desktop`、`/mobile` 的对象边界已经比这里更稳定，不需要混进同一提交。
