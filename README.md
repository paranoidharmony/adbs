# adbs

- **Android：`adbs`** 通过 ADB 进入自带的 Zsh，提供 Zim、自动建议、语法高亮、增强补全，以及 BusyBox、tree、curl、tcpdump 和 dig。
- **鸿蒙：`hdcs`** 通过 HDC 进入手机自带的 mksh，提供持久历史、路径补全、目录导航和 HiLog 快捷命令。

两者都不需要 root、安装手机应用或让手机在线。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/paranoidharmony/adbs/main/bootstrap.sh | bash
```

远程安装需要 Linux、Bash、Git 和 curl。安装器将仓库克隆到 `~/.liut/adbs`，再在 `~/.local/bin` 中创建四个链接：Android 用 `adbs` 或 `sbda`，鸿蒙用 `hdcs` 或 `cshd`，不覆盖已有的其他命令。请确保 `~/.local/bin` 在 `PATH` 中。已有本地克隆直接运行 `./install.sh`。

## 鸿蒙：hdcs

主机需要 Python 3 和鸿蒙 SDK 的 `hdc`（已在 Linux、HDC 3.2.0f 上验证），不需要 adb。设备需已授权调试，`/system/bin/sh` 是 mksh，且 shell 用户可写 `/data/local/tmp`。

```bash
hdcs                      # 进入手机的增强 shell，exit 返回电脑
hdcs -t 设备标识           # 指定 hdc list targets 中的设备
hdcs --check              # 同步并检查配置，不进入终端
cshd                      # 安装后与 hdcs 等价，支持相同参数
```

进入后，方向键翻历史，Tab 补全文件名；`ll` 查看目录，`..` 回上级，`ff '*.log'` 查找文件，`hlog TAG` 按标签跟踪日志（Ctrl-C 停止）。输入 `hdcs-help` 查看快捷命令。

连接时校验 `hdcshome/mkshrc`，仅在内容变化时推送到 `/data/local/tmp/hdcshome`（使用系统 `sha256sum`）。历史记录在该设备的 `~/history`，个人别名放在 `~/.mkshrc.local`，均不会被同步覆盖。`~` 只在本次增强会话中改变，普通 `hdc shell` 不受影响。这不是 Zsh，没有 Zim 插件，也不改变系统调试权限。批处理继续用 `hdc shell COMMAND`。

[真机适配记录：交互验证与 Zsh 执行阻塞](docs/hdcs.md)

## Android：adbs

主机需要支持 `push --sync` 的 adb，不需要 HDC 或 Python。

```bash
adbs             # 同步工具，进入 /sdcard/workspace；exit 返回电脑
adbs -s SERIAL   # 多台设备时指定序列号
adbs --check     # 在设备上验证运行环境
adbs --update    # 在主机上快进拉取更新，成功后执行更新后的 install.sh，无需连接手机
```

支持已授权 ADB 调试的 `arm64-v8a` 设备。交互启动时显示欢迎语；实际推送文件时额外显示同步数量，不打印跳过统计。进入时自动创建并打开 `/sdcard/workspace`；共享存储不可用时提示并回到 HOME。`cd` 无参数时回到当前身份的 HOME。

常用交互别名（普通和 root 会话均可用）：

| 命令 | 用途 |
| --- | --- |
| `ll` / `lla` | 长列表、易读大小；`lla` 也显示隐藏项。`la` 则只列名称（含隐藏项）。 |
| `lt` / `lk` | 长列表按修改时间或大小排序，最新或最大的在最后。 |
| `..` / `...` / `ws` | 返回上一级、上两级或 `/sdcard/workspace`。 |
| `t2` / `t3` | 显示两层或三层目录树，可追加路径或 `-a`。 |

`ls` 和 `ll` 系列仅在终端输出颜色，管道和重定向得到纯文本。启动 Zsh 前设置 `NO_COLOR=1` 可关闭列表颜色；个人别名仍可在 `~/.zshrc.local` 覆盖。

在 KernelSU 已授权的设备上，有两种用法：

- `sudo tcpdump -D`：以 root 运行一条命令，此例只列出抓包接口。命令使用 `adbs` 的工具和动态库，保留当前目录；结束后仍在原会话，退出码可用 `$?` 查看。仅支持 `sudo 命令 [参数...]`，不实现 Linux sudo 的选项。
- `su`：进入增强 root Zsh，保留当前目录，适合连续执行多条命令；`exit` 返回原会话。`su -c ...` 等带参数调用原样透传。

这些快捷方式仅在 `adbs` 中生效，不修改系统或替代 KernelSU 授权。root 会信任 ADB shell 同步的程序和公共配置。

| 设备路径 | 用途与更新行为 |
| --- | --- |
| `/data/local/tmp/adbs/usr/`、`etc/` | 唯一的同步目标，分别来自仓库的 `android/usr/`、`android/etc/`。同名发行文件可被覆盖，不删除设备独有文件。 |
| `/data/local/tmp/adbs/home/shell/`、`home/root/` | 按实际 UID 选择，首次使用时创建。各自保存历史、补全缓存、Zim 初始化脚本及个人配置 `~/.zshrc.local`，不参与同步。 |
| `/sdcard/workspace/` | 两个身份共用的工作目录，不投放、不覆盖、不清理工作文件。 |

公共配置位于 `android/etc/`：`.zshrc` 是入口，依次加载 `zsh/zim.zsh`（插件初始化和补全缓存）、`zsh/aliases.zsh`（交互别名）、`zsh/kernelsu.zsh`（`su`、`sudo`），最后加载当前用户的 `~/.zshrc.local`。增减 Zim 插件改 `.zimrc`。

旧目录 `/data/local/tmp/adbshome` 不再使用，也不会自动删除；如需保留旧历史或 `.zshrc.local`，可手动复制到新普通用户 HOME。

**`dig` 的已知限制：**内置 `dig` 启动时会读取 Termux 私有的 `resolv.conf`。如果文件不存在，仍可用 `dig @服务器 域名` 查询；如果文件存在但普通 ADB shell 无权读取，连 `dig -v` 都会失败，`adbs --check` 也会如实报错。在已授权的 KernelSU 设备上改用 `sudo dig @服务器 域名` 即可，无需修改 Termux 权限。

第三方组件来源和许可：[Zsh 与 Zim](ZSH-SOURCES.md) · [网络工具及运行库](tools-sources.md)。
