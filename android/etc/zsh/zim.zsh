# 插件源码和配置共享，Zim 初始化脚本和补全缓存归当前 HOME。
fpath=($ADBS_ROOT/usr/share/zsh/functions/**/*(/N) $ADBS_ROOT/usr/share/zsh/functions)
ZIM_HOME=$HOME/.cache/zim
ZIM_CONFIG_FILE=$ZDOTDIR/.zimrc
zstyle ':zim' disable-version-check yes
zstyle ':zim' disable-compile yes
zstyle ':zim:glob' case-sensitivity sensitive
zstyle ':zim:completion' dumpfile "$HOME/.cache/zcompdump"
zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"
if [[ ! -s $ZIM_HOME/init.zsh || $ZIM_CONFIG_FILE -nt $ZIM_HOME/init.zsh || $ADBS_ROOT/usr/share/zim/zimfw.zsh -nt $ZIM_HOME/init.zsh ]]; then
  source "$ADBS_ROOT/usr/share/zim/zimfw.zsh" build || return 1
fi
source "$ZIM_HOME/init.zsh"
