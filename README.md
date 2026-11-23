# adbs

通过 ADB 进入 Android 上的 Zsh：自带 Zim、自动建议、语法高亮、增强补全，以及 BusyBox、curl、tcpdump 和 dig。无需 root 或安装 Termux，手机不用联网。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/paranoidharmony/adbs/main/bootstrap.sh | bash
```

主机需要 Linux、Bash、Git、curl 和支持 `push --sync` 的 adb。安装器将仓库克隆到 `~/.liut/adbs`，再调用 `install.sh` 把命令链接到 `~/.local/bin/adbs`，不会覆盖已有的其他命令。请确保 `~/.local/bin` 在 `PATH` 中。已有本地克隆也可直接运行 `./install.sh`。

## 使用和更新

```bash
adbs             # 同步环境并进入 Zsh，exit 返回电脑
adbs -s SERIAL   # 多台设备时指定序列号
adbs --check     # 在设备上验证运行环境
adbs --update    # 在主机仓库执行 git pull --ff-only，不需要连接手机
```

支持已授权 USB 调试的 `arm64-v8a` 设备。首次连接推送 `adbshome/` 到 `/data/local/tmp/adbshome`，之后只推送有变化的文件。更新后下次连接即生效；同步不会删除设备独有的文件。

自定义配置可改仓库中的 `adbshome/.zshrc`、`.zimrc`，仅在某台设备使用的配置放在设备的 `~/.zshrc.local`。不要把凭据放入本机 `adbshome/`。内置命令仍受 Android 权限限制。

第三方组件来源和许可：[Zsh 与 Zim](ZSH-SOURCES.md) · [网络工具及运行库](tools-sources.md)。
