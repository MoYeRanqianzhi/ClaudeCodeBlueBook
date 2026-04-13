# IDE、Desktop、Mobile 与会话接续专题

## 用户目标

不是把 Claude Code 锁死在一个终端窗口里，而是更稳地处理这些真实场景：

- 把当前工作接进 IDE
- 把当前会话继续到 Claude Desktop
- 给移动端准备接入入口
- 在 remote mode 下把同一工作对象交给别的前端继续消费

如果你的误判已经从“接续入口”滑到“远端输入、桥接审批与本地会话到底是不是同一件事”，继续读 [20-远端输入注入、桥接审批与会话接续专题.md](./20-%E8%BF%9C%E7%AB%AF%E8%BE%93%E5%85%A5%E6%B3%A8%E5%85%A5%E3%80%81%E6%A1%A5%E6%8E%A5%E5%AE%A1%E6%89%B9%E4%B8%8E%E4%BC%9A%E8%AF%9D%E6%8E%A5%E7%BB%AD%E4%B8%93%E9%A2%98.md)。

如果你想先把“稳定接续面”和“条件远端面”拆开，再决定要不要进入远端 deeper runtime，先读 [多前端接续与条件远端/README.md](./%E5%A4%9A%E5%89%8D%E7%AB%AF%E6%8E%A5%E7%BB%AD%E4%B8%8E%E6%9D%A1%E4%BB%B6%E8%BF%9C%E7%AB%AF/README.md)。

## 第一性原理

“多前端”不是一个对象，而是四种不同对象：

- 开发环境连接：`/ide`
- 当前会话交接：`/desktop`
- 设备准备与应用获取：`/mobile`
- remote mode 下的接续地址：`/session`

相邻但不同类的还有：

- 让本机变成宿主：`/remote-control`
- 设置 teleport 默认远程环境：`/remote-env`
- 条件浏览器前端：`/chrome`
- 条件输入通道：`/voice`

如果不先把这些对象拆开，最容易写错的就是：

- 把下载入口写成会话接续入口
- 把 viewer 入口写成 host 入口
- 把条件前端写成稳定主线

## 正确入口

### `/ide`

这是稳定公开的开发环境连接入口。

它的真实目标不是“打开某个编辑器”，而是：

- 检测当前可连接的 IDE
- 区分可用与不可用实例
- 只在工作区匹配时给出连接选项
- 处理 auto-connect 与当前连接状态

对用户来说，更准确的理解是：

- `/ide` 管的是“Claude Code 与 IDE 的连接关系”
- 不是“启动编辑器”

### `/desktop`

这是把当前会话继续到 Claude Desktop 的入口。

它是公开能力，但有明确前提：

- `availability: ['claude-ai']`
- 平台只支持 `macOS`，以及 `Windows x64`

所以它是“稳定但产品面/平台面有前提”的交接入口，而不是所有环境都可用的通用命令。

更进一步：

- 真正 handoff 前还会检查 Desktop 安装 / 版本
- 成功后会把当前 CLI 会话切到 Desktop，而不是两边并行继续

### `/mobile`

这是设备准备入口，不是当前会话 handoff 入口。

它会：

- 展示 iOS / Android 下载二维码
- 允许在两个平台之间切换

它解决的是“把 Claude app 装到手机上”，不是“把这条会话立刻接到手机里继续跑”。

### `/session`

这条线属于“已进入 remote mode 后的会话接续入口”。

它的公开合同非常明确：

- 只有在 remote session URL 已就绪时，才真正交付 URL / QR 这一类 viewer 接续对象
- 未进入 remote mode 时会直接提示先用 `claude --remote`
- 有 URL 时会尽量生成 QR code，但二维码失败并不阻断 URL 交付

更稳的理解是：

- `getIsRemoteMode()` 为真，说明你已经站在 remote 语境里
- 但这不自动等于 remote session URL 一定已经可交付
- attached viewer 一类场景也可能 remote bit 为真，但当前前端并不拥有那条可继续分享的 URL

所以 `/session` 的主对象是：

- 当前 remote session 的接续地址

而不是：

- `/resume` 的替代品
- 普通会话信息页

还要再补一条高危边界：

- `/session` 的 alias 里有 `/remote`
- 但“创建远程会话”真正对应的是 CLI `--remote`
- `/session` 是稳定 viewer 接续面；`--remote` 则是把这条会话物化出来的灰度创建面

不要把 slash command 和 CLI flag 写成同一条链。

### 补充：我卡在 attach 后已经看见 history init banner，但 slash / 恢复语义还是不一样

先读：

- [05-控制面深挖/211-completion signal、system.init dual-axis、history attach restore 与 loading edge：为什么 116、117、118、119、120、121 不是线性后续页，而是三组相邻配对分叉.md](../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/211-completion%20signal%E3%80%81system.init%20dual-axis%E3%80%81history%20attach%20restore%20%E4%B8%8E%20loading%20edge%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20116%E3%80%81117%E3%80%81118%E3%80%81119%E3%80%81120%E3%80%81121%20%E4%B8%8D%E6%98%AF%E7%BA%BF%E6%80%A7%E5%90%8E%E7%BB%AD%E9%A1%B5%EF%BC%8C%E8%80%8C%E6%98%AF%E4%B8%89%E7%BB%84%E7%9B%B8%E9%82%BB%E9%85%8D%E5%AF%B9%E5%88%86%E5%8F%89.md)
- [05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md](../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/118-convertUserTextMessages%E3%80%81sentUUIDsRef%E3%80%81fetchLatestEvents%28anchor_to_latest%29%E3%80%81pageToMessages%20%E4%B8%8E%20source-blind%20append%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20viewerOnly%20%E7%9A%84%E6%9C%AC%E5%9C%B0%20echo%20%E5%8E%BB%E9%87%8D%E3%80%81history%20attach%20overlap%20%E4%B8%8E%20transcript%20%E8%BF%BD%E5%8A%A0%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%20replay%20dedup.md)
- [05-控制面深挖/121-useAssistantHistory、fetchLatestEvents(anchor_to_latest)、pageToMessages、useRemoteSession onInit 与 handleRemoteInit：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义.md](../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/121-useAssistantHistory%E3%80%81fetchLatestEvents%28anchor_to_latest%29%E3%80%81pageToMessages%E3%80%81useRemoteSession%20onInit%20%E4%B8%8E%20handleRemoteInit%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%20history%20init%20banner%20%E5%9B%9E%E6%94%BE%E4%B8%8E%20live%20slash%20%E6%81%A2%E5%A4%8D%E4%B8%8D%E6%98%AF%E5%90%8C%E4%B8%80%E7%A7%8D%20attach%20%E6%81%A2%E5%A4%8D%E8%AF%AD%E4%B9%89.md)

这组页解决的是：

- 为什么 attach 后看到的 transcript replay，不等于 live bootstrap / command-surface restore
- 为什么 history banner、live slash、local echo 去重与 history/live overlap 不是同一条恢复

不是：

- `/session` 到底能不能生成 URL
- `/desktop`、`/mobile` 与 `/ide` 谁才是 continuation 入口

## 隐藏的运行时合同

### `/ide` 只连接“当前工作现场可用”的 IDE

它不是发现到任何 IDE 就都列出来，而是会区分：

- 当前 cwd/workspace 匹配的可用实例
- 正在运行但 workspace 不匹配的不可用实例

这说明 IDE 接入不是泛设备发现，而是工作面连接。

### `/desktop` 是“当前会话 handoff”，不是新建桌面会话

它的实现直接进入 `DesktopHandoff`，目标是把当前对象带过去，而不是让用户在桌面端重新开局。

### `/mobile` 是设备获取面

因此不要把它写成 session continuation 功能。

### `/session` 是 viewer 侧接续，不是 host 侧控制

它依赖当前已经处于 remote mode。

与之相邻但完全不同的，是 `remote-control` 这类 host 侧能力。

### `/remote-control` 与 `/remote-env` 都不是稳定默认主线

- `/remote-control` 受 `BRIDGE_MODE` + `isBridgeEnabled()` 控制，并且默认隐藏
- `/remote-env` 受 `claude.ai` 订阅与 `allow_remote_sessions` policy 共同控制

所以它们更适合写成条件能力，而不是 userbook 的默认多前端主线。

尤其不要承诺用户能在 web / mobile 的 remote-control 场景里自由跑所有本地 `local-jsx` 命令；bridge 下有单独的安全命令过滤。

### `/chrome` 与 `/voice` 都是条件前端

- `/chrome` 是 `claude-ai` + 非非交互会话下的 `Beta` 设置面
- `/voice` 是 `claude-ai` 条件能力，并且真正开启前要过 auth、录音环境、依赖、麦克风权限多重检查

## 最容易误用的点

### 把 `/mobile` 当作“继续当前会话到手机”

它解决的是 app 下载，不是当前 session handoff。

### 把 `/session` 当成“所有会话都能看的接续页”

它只在 remote mode 下成立。

### 把 `/remote-control` 当成 `/session` 的增强版

一个是 viewer 接续，一个是 host 宿主；对象根本不同。

### 把 `/ide` 当作“打开编辑器按钮”

它实际在管理连接状态、workspace 匹配和 auto-connect。

### 把 `/voice` 和 `/chrome` 当纯 UI 开关

它们背后都有更强的资格、环境或依赖前提。

## 稳定面与条件面

### 稳定主线

- `/ide`
- `/mobile`

### 稳定但带前提

- `/desktop`
- `/session`

### 条件公开或隐藏面

- `/remote-control`
- `/remote-env`
- `/chrome`
- `/voice`

## 用户策略

更稳的多前端路径通常是：

1. 想把 Claude Code 接进本地开发现场时，先用 `/ide`。
2. 想把当前工作带到 Claude Desktop 时，再用 `/desktop`。
3. 只是给手机准备入口时，用 `/mobile`，不要误当成当前会话继续。
4. 只有在已经进入 remote mode 时，才把 `/session` 当成接续入口。
5. 遇到 `/remote-control`、`/chrome`、`/voice` 这类相邻能力时，先默认它们是条件面，不要直接纳入稳定主线。

## 源码锚点

- `src/commands/ide/index.ts`
- `src/commands/ide/ide.tsx`
- `src/commands/desktop/index.ts`
- `src/commands/desktop/desktop.tsx`
- `src/commands/mobile/index.ts`
- `src/commands/mobile/mobile.tsx`
- `src/commands/session/index.ts`
- `src/commands/session/session.tsx`
- `src/commands/bridge/index.ts`
- `src/commands/remote-env/index.ts`
- `src/commands/chrome/index.ts`
- `src/commands/chrome/chrome.tsx`
- `src/commands/voice/index.ts`
- `src/commands/voice/voice.ts`
