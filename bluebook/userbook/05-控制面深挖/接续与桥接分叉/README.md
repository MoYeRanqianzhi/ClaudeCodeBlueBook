# 接续与桥接分叉

这个目录不是新的编号范围图，

而是给现有 `168-190` 接力簇补一个可浏览的物理入口。

这里保护的首先是：

- 阅读骨架稳定

不是：

- 目录里出现的中间节点名都已经属于稳定公开能力

如果你已经知道自己会在：

- headless 接续来源
- create-context 子树
- teleport / model / bridge 分叉
- bridge ingress / permission tail / remote surface 后继线

之间来回跳，这里应该先于平铺文件列表阅读。

## 第一性原理

这组文档真正想回答的不是：

- “168-190 按编号应该怎么顺着读”

而是：

- `218` 怎样把 `168-179` 收成一棵子树
- `219` 怎样把这棵子树继续长成 teleport、model、bridge 三条后继线
- 为什么后续的 `197 / 203 / 204 / 206` 不该被重新误写成互不相干的旁枝

所以这个目录的作用只是：

- 把现有 range map 和它们已经长出来的后继深线收成一个可浏览入口

不是：

- 再制造一张新的 umbrella map

## 先读哪一页

### 1. 我还在 `168-179` 的子树里

先读：

- [../218-headless source、bridge authority 与 create-context 子树：为什么 168-179 不是线性十二连.md](../218-headless%20source、bridge%20authority%20与%20create-context%20子树：为什么%20168-179%20不是线性十二连.md)

它负责固定：

- headless source
- bridge authority
- `session_context`

这些对象如何长成一棵子树。

### 2. 我已经要往 teleport / model / bridge 三股后继线继续分

再读：

- [../219-teleport、model 与 bridge 分支：为什么 180-190 不是线性十一连.md](../219-teleport、model%20与%20bridge%20分支：为什么%20180-190%20不是线性十一连.md)

它负责固定：

- `179 -> 180` 的 teleport runtime
- `182 / 184 -> 185 -> 187 -> 188` 的 model line
- `181 -> 183 -> 186 -> 189 -> 190 -> 191 -> {192, 193 -> 206}` 的 bridge 后继线

### 3. 我已经掉进 bridge ingress / permission tail / remote surface 的后继问题

按问题类型继续：

- ingress 阅读链：
  [../197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend 与 pendingPermissionHandlers：为什么 bridge ingress 的 191-196 不是并列碎页，而是一条六层阅读链.md](../197-handleIngressMessage、recentInboundUUIDs、onPermissionResponse、extractInboundMessageFields、resolveAndPrepend%20与%20pendingPermissionHandlers：为什么%20bridge%20ingress%20的%20191-196%20不是并列碎页，而是一条六层阅读链.md)
- permission tail 分叉：
  [../203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题.md](../203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host%20与%20applyPermissionUpdate：为什么%20permission%20tail%20的%20196、198、199、201、202%20不是并列尾页，而是从%20verdict%20ledger%20分叉出去的四种后继问题.md)
- remote surface 分叉：
  [../204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题.md](../204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode%20与%20useReplBridge：为什么%20remote%20surface%20的%20132、135、138、141、142、143%20不是并列%20remote%20页，而是从%20front-state%20consumer%20topology%20分叉出去的五种后继问题.md)
- blocked-state 厚薄：
  [../206-StructuredIO、sessionState、remoteBridgeCore、pending_action、requires_action_details 与 reportState：为什么 can_use_tool 不等于 requires_action-pending_action，而 bridge blocked-state publish 只签裸 blocked bit.md](../206-StructuredIO、sessionState、remoteBridgeCore、pending_action、requires_action_details%20与%20reportState：为什么%20can_use_tool%20不等于%20requires_action-pending_action，而%20bridge%20blocked-state%20publish%20只签裸%20blocked%20bit.md)

## 这层目录保护什么

- 保护的是一个可浏览入口，而不是新的结构编号。
- 保护的是 `218 -> 219 -> downstream branches` 的接力关系。
- 不把 `197 / 203 / 204 / 206` 写成和 `218 / 219` 平级的另一套范围图。
- 不在这一轮移动或重命名任何现有编号页。
