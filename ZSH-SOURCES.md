# Zsh 环境来源

`android/usr/` 中的 Zsh 运行时来自 Termux `aarch64` 软件包，不是主机的 Linux 可执行文件。

| 组件 | 仓库内位置 | 上游 |
| --- | --- | --- |
| Zsh、本体函数、运行库、terminfo | `bin/zsh`、`lib/`、`share/{zsh,terminfo}` | [Termux 软件包及构建配方](https://github.com/termux/termux-packages)，原包许可证保存在 `share/doc/` |
| Zimfw | `share/zim/zimfw.zsh` | [zimfw v1.21.1](https://github.com/zimfw/zimfw/tree/v1.21.1)，许可证随附 |
| Zim input | `share/zim/modules/input/` | [zimfw/input bdec2b3](https://github.com/zimfw/input/tree/bdec2b372f8bd16a072d30ebc447a22dad52cfb4)，许可证随附 |

本地为 Zimfw 增加 `disable-compile` 开关，避免构建时在共享插件源码旁生成 `.zwc`。内置模块位于 `share/zim/modules/`。除上表的 `input`，其余模块按下列上游修订引入，仅保留运行文件及许可证（历史搜索插件的授权声明在脚本头部）：

| zimfw 模块 | zsh-users 插件 |
| --- | --- |
| [environment@d4bceaa](https://github.com/zimfw/environment/tree/d4bceaa) | [zsh-completions@989b232](https://github.com/zsh-users/zsh-completions/tree/989b232) |
| [termtitle@b0de778](https://github.com/zimfw/termtitle/tree/b0de778) | [zsh-syntax-highlighting@e6683f2](https://github.com/zsh-users/zsh-syntax-highlighting/tree/e6683f2) |
| [utility@c7ed9b9](https://github.com/zimfw/utility/tree/c7ed9b9) | [zsh-history-substring-search@a0bdb0d](https://github.com/zsh-users/zsh-history-substring-search/tree/a0bdb0d) |
| [duration-info@c887236](https://github.com/zimfw/duration-info/tree/c887236) | [zsh-autosuggestions@85919cd](https://github.com/zsh-users/zsh-autosuggestions/tree/85919cd) |
| [prompt-pwd@1531846](https://github.com/zimfw/prompt-pwd/tree/1531846) | |
| [asciiship@56c0a72](https://github.com/zimfw/asciiship/tree/56c0a72) | |
| [completion@213d38b](https://github.com/zimfw/completion/tree/213d38b) | |

为减少 ADB 首次传输，发行内容省略了 12 个专用补全：Zsh 的 `_git`、`_gcc`、`_perforce`、`_zfs`、`_ffmpeg`、`_postgresql`，以及 zsh-completions 的 `_flutter`、`_ghc`、`_golang`、`_concourse`、`_mix`、`_conan`。保留基础框架和手机调试命令的补全。旧设备上的同名文件不主动删除。

以上位置相对于 `android/usr/`。更新 Android 命令时，需同时核实 ELF 架构、运行时库名和依赖、硬编码的 Termux 路径，以及上游许可证。不要把手机上生成的历史、缓存或凭据复制回仓库。
