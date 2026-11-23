#!/usr/bin/env bash
# 从任意工作目录运行；按本脚本的真实位置定位同仓库的 adbs。
set -euo pipefail
repo=$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")
src=$repo/adbs
bin=$HOME/.local/bin
dest=$bin/adbs
[[ -f $src && -x $src ]] || { printf '找不到可执行文件：%s\n' "$src" >&2; exit 1; }
mkdir -p -- "$bin"
if [[ -L $dest && $dest -ef $src ]]; then
  printf '链接已就绪：%s\n' "$dest"
elif [[ -e $dest || -L $dest ]]; then
  printf '未覆盖已有文件或链接：%s。请先检查并移走它，再运行安装脚本。\n' "$dest" >&2
  exit 1
else
  ln -sT -- "$src" "$dest"
  printf '已链接：%s → %s\n' "$dest" "$src"
fi
case ":${PATH:-}:" in
  *":$bin:"*) ;;
  *) printf '要直接运行 adbs，请在 shell 配置中添加：export PATH="$HOME/.local/bin:$PATH"\n' ;;
esac
