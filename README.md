# adbs

- **Android：`adbs`** 通过 ADB 进入自带的 Zsh，提供 Zim、自动建议、语法高亮、增强补全，以及 BusyBox、curl、tcpdump 和 dig。
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
adbs             # 同步环境并进入 Zsh，exit 返回电脑
adbs -s SERIAL   # 多台设备时指定序列号
adbs --check     # 在设备上验证运行环境
adbs --update    # 在主机上快进拉取更新，成功后执行更新后的 install.sh，无需连接手机
```

支持已授权 USB 调试的 `arm64-v8a` 设备。首次连接推送 `adbshome/` 到 `/data/local/tmp/adbshome`，之后只推送有变化的文件。更新后下次连接即生效；同步不会删除设备独有的文件。

自定义配置可改仓库中的 `adbshome/.zshrc`、`.zimrc`，仅在某台设备使用的配置放在设备的 `~/.zshrc.local`。不要把凭据放入本机 `adbshome/`。内置命令仍受 Android 权限限制。

第三方组件来源和许可：[Zsh 与 Zim](ZSH-SOURCES.md) · [网络工具及运行库](tools-sources.md)。
