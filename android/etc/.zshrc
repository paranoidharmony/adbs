HISTFILE=$HOME/.local/state/zsh_history

# 先初始化 Zim，再应用 adbs 的交互设置；个人配置始终最后加载。
source "$ZDOTDIR/zsh/zim.zsh" || return 1
# Zim environment 默认开启 NO_CLOBBER；保留 Android shell 常用的 > 覆盖语义。
unsetopt noclobber
source "$ZDOTDIR/zsh/aliases.zsh" || return 1
source "$ZDOTDIR/zsh/kernelsu.zsh" || return 1
[[ ! -f $HOME/.zshrc.local ]] || source "$HOME/.zshrc.local"
