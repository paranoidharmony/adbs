# hdcs 真机适配记录

**结论：当前设备可以通过 HDC 增强系统 mksh；尚不能以普通 `shell` 用户直接运行推送到 `/data/local/tmp` 的 Zsh。** 以下结果来自一台 aarch64 设备（系统报告 OpenHarmony-7.0.0.111、API 26）和 Linux 主机上的 HDC 3.2.0f，不代表所有鸿蒙设备。

## 已验证的路径

- `/bin/sh` 与 `/system/bin/sh` 是同一文件，实际为 MirBSD Korn Shell R59。普通 shell 的 `PATH` 中未发现第二种交互 shell；系统 Toybox 也没有提供 shell 命令。
- `hdc shell 'tty'` 返回 `not a tty`，无参数 `hdc shell` 则能分配 `/dev/pts/*`。因此 `hdcs` 先打开交互会话，再启动带专用 HOME 和配置的系统 mksh，不改系统默认 shell。
- 真机验证通过：配置首次同步、未变化时跳过同步、保留个人配置、Tab 文件名补全、跨会话历史、按名称查找文件、Ctrl-C 中断日志跟踪、`exit` 返回主机。用法见 [README](../README.md#鸿蒙hdcs)。

## Zsh 为什么没有随包提供

测试对象为 [Harmonybrew Zsh 5.9](https://github.com/Harmonybrew/ohos-zsh/releases/tag/5.9) 的 `zsh-5.9-ohos-arm64.tar.gz`。其中的 `bin/zsh` 是 ARM64 ELF，所需加载器 `/lib/ld-musl-aarch64.so.1` 在设备上存在。

将 `bin/zsh` 推送到 `/data/local/tmp` 下新建的 shell 私有目录后，确认设备端与主机端 SHA-256 一致，属主为 `shell`，权限为 `0700`。在交互和非交互两种模式执行 `zsh --version`，均得到 `Permission denied`。**设备内立即读取 `$?` 为 `126`**；不能用主机上的 `hdc` 退出码替代这一判断。

阻塞发生在执行 Zsh 本身，尚未进入 Zim、补全或主题的验证阶段。现有证据排除了传输损坏和缺少文件执行位，**不足以区分签名要求、访问控制或其他系统策略**。若重启 Zsh 适配，应先确认目标设备是否有官方支持的独立 ELF 部署方式，并以普通 `shell` 用户成功运行 `zsh --version` 为第一项验收条件。
