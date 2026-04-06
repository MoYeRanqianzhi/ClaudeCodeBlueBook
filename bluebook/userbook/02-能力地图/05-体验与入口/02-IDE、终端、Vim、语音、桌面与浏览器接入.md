# IDE、终端、Vim、语音、桌面与浏览器接入

## Claude Code 不把终端当唯一前端

源码里的这组命令非常说明问题：

- `/ide`
- `/desktop`
- `/mobile`
- `/chrome`
- `/voice`
- `/session`
- `/remote-control`
- `/remote-env`

这代表 Claude Code 实际上是在做一个“多前端共享同一工作对象”的系统。

但这里先讲“前端与接入面”本身。

如果你要分辨：

- `/session`
- `/remote-control`
- `--remote`
- bridge host

请转到下一页，那一页专门写宿主生命周期。

## IDE 集成的价值

IDE 集成不是只为打开文件，而是让 Claude Code 能拿到：

- 编辑器状态。
- 选区。
- 自动连接能力。
- 差异查看与跳转能力。

这也是为什么源码里会有 `useIDEIntegration`、自动连接对话框和 IDE 安装状态管理。

## Vim、主题、颜色、按键绑定

`/vim`、`/theme`、`/color`、`/keybindings` 说明终端交互体验不是后置细节，而是正式产品面。

尤其 `src/vim/*` 的存在说明：

- Claude Code 不是简单复用 readline。
- 它在把“文本输入体验”本身当作可进化子系统。

## 语音与 Chrome 不是噱头，但也不是默认主线

语音模式与 Claude in Chrome 都有独立命令与模块，说明多模态和浏览器接入在源码里已经被认真建模：

- 语音走独立 feature gate、账户、依赖与权限检查链。
- Chrome 集成有自己的账户资格、设置与权限面。

这类能力不一定对所有用户稳定开放，但它们也不是概念验证，而是条件公开的正式产品方向。

## `desktop`、`voice`、`chrome` 都是邻接入口，但不是同一宿主生命周期

这一页只保留一个边界提醒：

- `/desktop` 更像当前会话的深链接管。
- `/voice` 是本地语音输入开关。
- `/chrome` 是浏览器扩展与 native host 接入。

它们和 `/remote-control` 都属于“多前端”语义，但不共享一条宿主状态机。

## 用户实践

### 本地仓库开发

终端 REPL 仍然是主面。

### 强 IDE 依赖工作流

优先启用 IDE 集成，让选区、跳转、差异查看进入系统循环。

### 跨设备继续工作

利用桌面、移动端与浏览器接入能力，不要把单个终端视作唯一会话容器。

## 源码锚点

- `src/commands/ide/index.ts`
- `src/hooks/useIDEIntegration.tsx`
- `src/commands/desktop/index.ts`
- `src/commands/mobile/index.ts`
- `src/commands/chrome/index.ts`
- `src/commands/voice/index.ts`
- `src/voice/*`
- `src/commands/keybindings/index.ts`
- `src/commands/vim/index.ts`
- `src/vim/*`
