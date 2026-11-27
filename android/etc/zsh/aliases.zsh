# Zim 的 ll、l、lt、lk 等别名都基于 ls；Android 的 Toybox 需要显式指定颜色模式。
if [[ -z ${NO_COLOR:-} ]]; then
  alias ls='ls --color=auto'
else
  # 部分 Toybox 即使传 --color=never 仍会着色；不传颜色参数才是纯文本。
  alias ls='command ls'
fi
alias la='ls -A' lla='ll -A'
alias ..='cd ..' ...='cd ../..' ws='cd /sdcard/workspace'
alias t2='tree -L 2' t3='tree -L 3'
