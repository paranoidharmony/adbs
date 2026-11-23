fpath=($HOME/.local/share/zsh/functions/**/*(/N) $HOME/.local/share/zsh/functions)
HISTFILE=$HOME/.local/state/zsh_history
# 历史大小和交互选项由 environment 管理。

# Zimfw、模块和生成的初始化脚本使用上游默认目录。
ZIM_HOME=${ZDOTDIR:-$HOME}/.zim
zstyle ':zim' disable-version-check yes
# /data 可以穿越但不能枚举；不让大小写无关的 glob 回溯扫描父目录。
zstyle ':zim:glob' case-sensitivity sensitive
zstyle ':zim:completion' dumpfile "$HOME/.cache/zcompdump"
if [[ ! -s $ZIM_HOME/init.zsh || $HOME/.zimrc -nt $ZIM_HOME/init.zsh || $ZIM_HOME/zimfw.zsh -nt $ZIM_HOME/init.zsh ]]; then
  source "$ZIM_HOME/zimfw.zsh" build || return 1
fi
source "$ZIM_HOME/init.zsh"
# environment 默认开启 NO_CLOBBER；保留 Android shell 常用的 > 覆盖语义。
unsetopt noclobber
[[ ! -f $HOME/.zshrc.local ]] || source "$HOME/.zshrc.local"
