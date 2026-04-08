# 多前端接续与条件远端

这个物理入口只处理一个高频误判：

- 同样看起来都像“跨设备 / 远端继续工作”，
- 但稳定接续入口、条件远端能力、viewer 接续面和 host 宿主面，其实不是同一层对象。

如果这几层不先拆开，

最容易把下面这些对象重新写成同一种“远程入口”：

- `/ide`
- `/desktop`
- `/mobile`
- `/session`
- `--remote`
- `/remote-control`
- `/remote-env`
- `/voice`
- `/chrome`

## 第一性原理

更稳的问法不是：

- “这些命令是不是都属于远端 / 多前端？”

而是：

- 我是在继续同一工作对象，
- 进入条件远端运行时，
- 还是把本机变成别的前端要接入的宿主。

按这条线，更稳的分层是：

1. 稳定接续面：`/ide`、`/desktop`、`/mobile`、`/session`、`--remote`
2. 条件远端面：`/remote-control`、`/remote-env`、`/voice`、`/chrome`
3. deeper runtime 分诊：远端输入、桥接审批、waiting bit、presence ledger、bridge 后台层

## 先判自己在哪一层

### 1. 我想在 IDE、Desktop、Mobile 或 remote session viewer 之间继续同一工作

先读：

1. [../16-IDE、Desktop、Mobile 与会话接续专题.md](../16-IDE%E3%80%81Desktop%E3%80%81Mobile%20%E4%B8%8E%E4%BC%9A%E8%AF%9D%E6%8E%A5%E7%BB%AD%E4%B8%93%E9%A2%98.md)
2. [../../02-能力地图/05-体验与入口/03-Session 与 Remote-control：多宿主生命周期.md](../../02-%E8%83%BD%E5%8A%9B%E5%9C%B0%E5%9B%BE/05-%E4%BD%93%E9%AA%8C%E4%B8%8E%E5%85%A5%E5%8F%A3/03-Session%20%E4%B8%8E%20Remote-control%EF%BC%9A%E5%A4%9A%E5%AE%BF%E4%B8%BB%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F.md)

这组主要回答：

- `IDE` 是开发环境连接
- `Desktop` 是当前会话 handoff
- `Mobile` 是设备准备与 app 获取
- `/session` / `--remote` 是 remote mode 下的稳定接续地址

### 2. 我已经滑到更宽口径的前端 / 远端总览

再读：

1. [../06-前端与远程专题.md](../06-%E5%89%8D%E7%AB%AF%E4%B8%8E%E8%BF%9C%E7%A8%8B%E4%B8%93%E9%A2%98.md)

这页更适合在你已经承认：

- 条件面会更多

之后，再去看：

- `/remote-control`
- `/voice`
- `/chrome`
- `/remote-env`

这些相邻但不属于稳定主线的对象。

### 3. 我已经掉进远端输入、审批或前后台分诊

按问题类型继续：

1. [../20-远端输入注入、桥接审批与会话接续专题.md](../20-%E8%BF%9C%E7%AB%AF%E8%BE%93%E5%85%A5%E6%B3%A8%E5%85%A5%E3%80%81%E6%A1%A5%E6%8E%A5%E5%AE%A1%E6%89%B9%E4%B8%8E%E4%BC%9A%E8%AF%9D%E6%8E%A5%E7%BB%AD%E4%B8%93%E9%A2%98.md)
2. [../23-远端前台运行、会话存在面与桥接后台分诊专题.md](../23-%E8%BF%9C%E7%AB%AF%E5%89%8D%E5%8F%B0%E8%BF%90%E8%A1%8C%E3%80%81%E4%BC%9A%E8%AF%9D%E5%AD%98%E5%9C%A8%E9%9D%A2%E4%B8%8E%E6%A1%A5%E6%8E%A5%E5%90%8E%E5%8F%B0%E5%88%86%E8%AF%8A%E4%B8%93%E9%A2%98.md)

这组主要回答：

- 为什么 viewer 接续会继续滑到输入注入 / bridge approval
- 为什么有时面对的是远端前台运行，有时是 session 存在面，有时是 bridge 后台层

## 稳定面、条件面与内部面

- 稳定可见：`/ide`、`/desktop`、`/mobile`、`/session`、`--remote`
- 条件公开：`/remote-control`、`/remote-env`、`/voice`、`/chrome`
- 内部/灰度：更细的 bridge rollout、viewer/host 内部状态字段、direct connect / mirror / env-less v2 等实现证据

## 苏格拉底式自审

### 问：我现在是在继续同一工作对象，还是在把本机变成宿主？

答：如果是后者，就不该再把 `/session` 和 `/remote-control` 写成同一种入口。

### 问：我是不是因为这些能力都跨设备，就把稳定接续和条件远端压成了同一层？

答：跨设备不等于同层；先分 viewer 接续、host 宿主、条件前端，再谈 deeper runtime。

### 问：我是不是已经滑到远端输入、审批或 presence ledger 问题，却还停留在“多前端入口”层？

答：如果已经在问这些问题，就应该继续读 `20` 或 `23`，不要在入口层兜圈子。
